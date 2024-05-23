//
//  WatchSessionService.swift
//  AvatarBuilder
//
//  Created by user on 22/05/2024.
//

import Foundation
import WatchConnectivity
import Combine

protocol WatchSessionServiceProtocol {
    var avatarPublisher: AnyPublisher<Avatar, Never> { get }
    func activateSession()
    func recieveValue(_ avatar: Avatar)
}

final class WatchSessionService: NSObject, WatchSessionServiceProtocol {
    
    private var avatarValue = CurrentValueSubject<Avatar, Never>(Avatar.placeholder)
    var avatarPublisher: AnyPublisher<Avatar, Never> { avatarValue.eraseToAnyPublisher() }
    
    private var cancellable: Set<AnyCancellable> = []
    
    override init() {
        super.init()
        activateSession()
    }
    
    func activateSession() {
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    func recieveValue(_ avatar: Avatar) {
        print("Value recieved: \(avatar.age)")
        avatarValue.value = avatar
    }
    
    private func updateContextWith(_ avatar: Avatar) {
        guard
            let avatarData = try? JSONEncoder().encode(avatar),
            let avatarDictionary = try? JSONSerialization.jsonObject(with: avatarData, options: .allowFragments) as? [String: Any]
        else {
            print("Error to update application context")
            return
        }
        print("Dictionary: \(avatarDictionary["age"])")
        do {
            try WCSession.default.updateApplicationContext([WatchConnectivityConstants.context: avatarDictionary])
        } catch {
            print("Error sending application context")
        }
    }
}

extension WatchSessionService: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        avatarPublisher
            .dropFirst()
            .sink { [weak self] avatar in
            self?.updateContextWith(avatar)
        }
        .store(in: &cancellable)
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let attributes = message[WatchConnectivityConstants.attributes] as? [String: String] else { return }
        print(attributes)
    }
    
}
