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
    func activateSession()
    func recieveValue(_ avatar: Avatar)
}

final class PhoneSessionService: NSObject, PhoneSessionServiceProtocol {
    
    static let shared = PhoneSessionService()
    
    private var avatarValue = CurrentValueSubject<Avatar, Never>(Avatar.placeholder)
    var avatarPublisher: AnyPublisher<Avatar, Never> { avatarValue.eraseToAnyPublisher() }
    
    private var cancellable: Set<AnyCancellable> = []
    
    private override init() {
        super.init()
    }
    
    func activateSession() {
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
        print("Activated")
    }
    
    func recieveValue(_ avatar: Avatar) {
        print("Valuer recieved: \(avatar.height)")
        avatarValue.value = avatar
    }
    
    private func updateContextWith(_ avatar: Avatar) {
//        guard
//            let avatarData = try? JSONEncoder().encode(avatar),
//            let avatarDictionary = try? JSONSerialization.jsonObject(with: avatarData, options: .allowFragments) as? [String: Any]
//        else {
//            print("Error to update application context")
//            return
//        }
//        print("Dictionary: \(avatarDictionary)")
//        do {
//            try WCSession.default.updateApplicationContext([WatchConnectivityConstants.context: avatarDictionary])
//        } catch {
//            print("Error sending application context")
//        }
    }
}

extension PhoneSessionService: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        guard let avatarDictionary = applicationContext[WatchConnectivityConstants.context] as? [String: Any],
              let avatarData = try? JSONSerialization.data(withJSONObject: avatarDictionary, options: .fragmentsAllowed)
        else {
            print("Error to recieve context")
            return
        }
        do {
            let avatar = try JSONDecoder().decode(Avatar.self, from: avatarData)
            print("Valuer recieved: \(avatar.height)")
            recieveValue(avatar)
        } catch {
            print("Error to decode data on wathes")
        }
    }
}
