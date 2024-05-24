//
//  ViewModel.swift
//  AvatarBuilder
//
//  Created by user on 21/05/2024.
//

import Foundation
import Combine

protocol ViewInputProtocol: AnyObject {
    func showAlert(with title: String, and message: String)
    func updateUIWith(age: String, weight: String, height: String)
}

protocol PresenterOutputProtocol {
    var numberOfImages: Int { get }
    init(viewController: ViewInputProtocol, dependencies: Presenter.Dependencies)
    func getImage(for item: Int) -> String
    func createAvatar(imageIdx: Int?, age: String?, height: String?, weight: String?)
}

class Presenter {
    struct Dependencies {
        var watchSessionService: WatchSessionServiceProtocol = WatchSessionService()
    }
    
    private let dependencies: Dependencies
    
    private var avatarImages: [String] = []
    private weak var view: ViewInputProtocol?
    
    @Published var avatar: Avatar = Avatar.placeholder
    
    private var isConnected: Bool = false
    
    private var cancellable: Set<AnyCancellable> = []
    
    required init(viewController: ViewInputProtocol, dependencies: Dependencies = .init()) {
        self.view = viewController
        self.dependencies = dependencies
        fetchAvatarImages()
        commonInit()
    }
    
    private func commonInit() {
        fetchAvatarImages()
        dependencies.watchSessionService.activateSession()
        subscribeToAvatarChanges()
        subscribeToWatchIsReachable()
    }
    
    deinit {
        cancellable.removeAll()
    }
    
    private func fetchAvatarImages() {
        avatarImages = AvatarImageFetcher.getAvatarImages(numbersOfImages: 6)
    }
    
    private func subscribeToAvatarChanges() {
        dependencies.watchSessionService.avatarPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] avatar in
                self?.view?.updateUIWith(age: avatar.age, weight: avatar.weight, height: avatar.height)
            }
            .store(in: &cancellable)
    }
    
    private func subscribeToWatchIsReachable() {
        dependencies.watchSessionService.isSessionReachable
            .receive(on: RunLoop.main)
            .sink { [weak self] isReachable in
                self?.isConnected = isReachable
            }
            .store(in: &cancellable)
    }
}

extension Presenter: PresenterOutputProtocol {
    
    var numberOfImages: Int { avatarImages.count }
    
    func getImage(for item: Int) -> String {
        guard (0..<numberOfImages).contains(item) else { return "" }
        return avatarImages[item]
    }
    
    func createAvatar(imageIdx: Int?, age: String?, height: String?, weight: String?) {
        guard let imageIdx = imageIdx,
              let age = age, !age.isEmpty,
              let height = height, !height.isEmpty,
              let weight = weight, !weight.isEmpty else {
            view?.showAlert(with: "Empty fields", and: "Hey! You should fill all fields out before sending your data.")
            return
        }
        let imageName = getImage(for: imageIdx)
        let data = AvatarImageFetcher.getImageData(imageName: imageName)
        let avatar = Avatar(image: data, age: age, height: height, weight: weight)
        sendContextToWatch(avatar)
    }
    
    private func sendContextToWatch(_ avatar: Avatar) {
        if isConnected {
            dependencies.watchSessionService.recieveValue(avatar)
        } else {
            view?.showAlert(with: "No Connection", and: "Please, make sure that your App Watches is connecnteed to the phone.")
        }
    }
}
