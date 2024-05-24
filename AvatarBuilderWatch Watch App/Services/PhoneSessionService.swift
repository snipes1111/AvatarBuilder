//
//  PhoneSessionService.swift
//  AvatarBuilderWatch Watch App
//
//  Created by user on 22/05/2024.
//

import Foundation
import WatchConnectivity
import Combine

protocol PhoneSessionServiceProtocol {
    var avatarPublisher: AnyPublisher<Avatar, Never> { get }
    var isSessionReachable: AnyPublisher<Bool, Never> { get }
    func activateSession()
    func updateContextWith(_ avatar: Avatar)
    func deactivateSession()
}

final class PhoneSessionService: NSObject, PhoneSessionServiceProtocol {
    
    private var avatarValue = CurrentValueSubject<Avatar, Never>(Avatar.placeholder)
    var avatarPublisher: AnyPublisher<Avatar, Never> { avatarValue.eraseToAnyPublisher() }
    
    private var isSessionReachableValue = CurrentValueSubject<Bool, Never>(false)
    var isSessionReachable: AnyPublisher<Bool, Never> { isSessionReachableValue.eraseToAnyPublisher() }
    
    private var cancellable: Set<AnyCancellable> = []
    
    func activateSession() {
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    func recieveValue(_ avatar: Avatar) {
        avatarValue.value = avatar
    }
    
    func updateContextWith(_ avatar: Avatar) {
        guard let avatarDictionary = Avatar.encode(avatar) else { return }
        do {
            try WCSession.default.updateApplicationContext([WatchConnectivityConstants.context: avatarDictionary])
        } catch {
            print("Error sending application context")
        }
    }
    
    func deactivateSession() {
        cancellable.removeAll()
    }
}

extension PhoneSessionService: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        if session.isReachable { isSessionReachableValue.value = true }
        else { isSessionReachableValue.value = false }
        
        avatarPublisher
            .dropFirst()
            .sink { [weak self] avatar in
                self?.updateContextWith(avatar)
            }
            .store(in: &cancellable)
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        guard let avatarDictionary = applicationContext[WatchConnectivityConstants.context] as? [String: Any],
              let avatar = Avatar.decode(avatarDictionary) else {
            print("Unable to decode context")
            return
        }
        recieveValue(avatar)
    }
}
