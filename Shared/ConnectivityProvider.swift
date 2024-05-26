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
    /// Publisher for the user created avatar
    var avatarPublisher: AnyPublisher<Avatar, Never> { get }
    /// Allows to track connectionn between phone and watch
    var isSessionReachable: AnyPublisher<Bool, Never> { get }
    /// Starts session between phone and watch and sets delegate for WatchConnectivity
    func activateSession()
    /// Update the avatar publisher
    func recieveValue(_ avatar: Avatar)
}

final class ConnectivityProvider: NSObject, ConnectivityProviderProtocol {
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
    
    deinit {
        cancellable.removeAll()
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

extension ConnectivityProvider: WCSessionDelegate {
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        cancellable.removeAll()
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        cancellable.removeAll()
    }
    #endif
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        checkConnection(for: session)
        subscribeToAvatarPublisher()
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        guard let avatarDictionary = applicationContext[WatchConnectivityConstants.context] as? [String: Any],
              let avatar = Avatar.decode(avatarDictionary)
        else {
            print("Error to recieve context")
            return
        }
        recieveValue(avatar)
    }
}

private extension ConnectivityProvider {
    func subscribeToAvatarPublisher() {
        avatarPublisher
            .dropFirst()
            .sink { [weak self] avatar in
            self?.updateContextWith(avatar)
        }
        .store(in: &cancellable)
    }
    
    func checkConnection(for session: WCSession) {
        if session.isReachable { isSessionReachableValue.value = true }
        else { isSessionReachableValue.value = false }
    }
}
