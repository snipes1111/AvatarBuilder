//
//  AvatarViewModel.swift
//  AvatarBuilderWatch Watch App
//
//  Created by user on 22/05/2024.
//

import Foundation
import Combine
import SwiftUI

final class AvatarViewModel: ObservableObject {
    enum AvatarAttribute: String {
        case age, height, weight
    }
    struct Dependencies {
        var phoneSessionService: ConnectivityProviderProtocol = ConnectivityProvider()
    }
    private let dependencies: Dependencies
    
    @Published private(set) var avatar: Avatar?
    /// Track the status of editing attribute
    @Published var isEditing: Bool = false
    /// Track the current attribute that is being edited right now
    @Published var editedAttribute: AvatarAttribute = .age
    /// Sets the text from textfield for editing attribute
    @Published var editedText: String = ""
    
    private var cancellable: Set<AnyCancellable> = []
    
    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
        activatePhoneSession()
    }
    
    deinit {
        cancellable.removeAll()
    }
    
    func editAttribute(_ value: String, _ attribute: AvatarAttribute) {
        isEditing.toggle()
        editedAttribute = attribute
        editedText = value
    }
    
    func confirmEditing() {
        guard var avatar = avatar else { return }
        switch editedAttribute {
        case .age: avatar.age = editedText
        case .height: avatar.height = editedText
        case .weight: avatar.weight = editedText
        }
        self.avatar = avatar
        isEditing.toggle()
        dependencies.phoneSessionService.recieveValue(avatar)
    }
}

private extension AvatarViewModel {
    /// Starts current phone session and track model changes and perform animation if avatar is passed to the viewModel 
    func activatePhoneSession() {
        dependencies.phoneSessionService.activateSession()
        dependencies.phoneSessionService.avatarPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] avatar in
                withAnimation(.easeInOut) {
                    self?.avatar = avatar
                }
            }
            .store(in: &cancellable)
    }
}
