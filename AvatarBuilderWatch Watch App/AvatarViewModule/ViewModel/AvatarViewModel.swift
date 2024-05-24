//
//  AvatarViewModel.swift
//  AvatarBuilderWatch Watch App
//
//  Created by user on 22/05/2024.
//

import Foundation
import Combine

final class AvatarViewModel: ObservableObject {
    enum AvatarAttribute: String {
        case age, height, weight
    }
    struct Dependencies {
        var phoneSessionService: PhoneSessionServiceProtocol = PhoneSessionService()
    }
    private let dependencies: Dependencies
    
    @Published private(set) var avatar: Avatar?
    @Published var isEditing: Bool = false
    @Published var editedAttribute: AvatarAttribute = .age
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
        dependencies.phoneSessionService.updateContextWith(avatar)
    }
}

private extension AvatarViewModel {
    func activatePhoneSession() {
        dependencies.phoneSessionService.activateSession()
        dependencies.phoneSessionService.avatarPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] avatar in
                self?.avatar = avatar
            }
            .store(in: &cancellable)
    }
}
