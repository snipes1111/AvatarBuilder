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
}

protocol PresenterOutputProtocol {
    var numberOfImages: Int { get }
    init(viewController: ViewInputProtocol)
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
    
    required init(viewController: ViewInputProtocol) {
        self.view = viewController
        self.dependencies = Dependencies()
        fetchAvatarImages()
    }
    
    private func fetchAvatarImages() {
        avatarImages = AvatarImageFetcher.getAvatarImages(numbersOfImages: 6)
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
        dependencies.watchSessionService.recieveValue(avatar)
    }
}
