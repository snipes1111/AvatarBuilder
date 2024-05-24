//
//  ConnectivityProvider.swift
//  AvatarBuilder
//
//  Created by user on 24/05/2024.
//

import Foundation
import WatchConnectivity
import Combine

protocol ConnectivityProviderProtocol {
    var avatarPublisher: AnyPublisher<Avatar, Never> { get }
    var isSessionReachable: AnyPublisher<Bool, Never> { get }
    func activateSession()
    func recieveValue(_ avatar: Avatar)
}

extension ConnectivityProviderProtocol where Self: WCSessionDelegate {
    func activateSession() {
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
}

final class ConnectivityProvider: NSObject {
    private var avatarValue = CurrentValueSubject<Avatar, Never>(Avatar.placeholder)
    var avatarPublisher: AnyPublisher<Avatar, Never> { avatarValue.eraseToAnyPublisher() }
    
    private var isSessionReachableValue = CurrentValueSubject<Bool, Never>(false)
    var isSessionReachable: AnyPublisher<Bool, Never> { isSessionReachableValue.eraseToAnyPublisher() }
    
    private var cancellable: Set<AnyCancellable> = []
    
    func recieveValue(_ avatar: Avatar) {
        print("Value recieved on the phone")
        avatarValue.value = avatar
    }
    
    private func updateContextWith(_ avatar: Avatar) {
        guard let avatarDictionary = Avatar.encode(avatar)
        else {
            print("Error to update application context")
            return
        }
        do {
            try WCSession.default.updateApplicationContext([WatchConnectivityConstants.context: avatarDictionary])
        } catch {
            print("Error sending application context")
        }
    }
}
