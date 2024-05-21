//
//  ViewModel.swift
//  AvatarBuilder
//
//  Created by user on 21/05/2024.
//

import Foundation

protocol ViewModelProtocol {
    var numberOfImages: Int { get }
    func getImage(for item: Int) -> String
}

class ViewModel {
    private var avatarImages: [String] = []
    
    init() {
        fetchAvatarImages()
    }
    
    private func fetchAvatarImages() {
        avatarImages = AvatarImages.getAvatarImages(numbersOfImages: 6)
    }
}

extension ViewModel: ViewModelProtocol {
    var numberOfImages: Int { avatarImages.count }
    func getImage(for item: Int) -> String {
        guard (0..<numberOfImages).contains(item) else { return "" }
        return avatarImages[item]
    }
}
