//
//  AvatarImages.swift
//  AvatarBuilder
//
//  Created by user on 21/05/2024.
//

import Foundation

struct AvatarImages {
    private static let imagePrefix: String = "avatar"
    
    static func getAvatarImages(numbersOfImages: Int) -> [String] {
        (1...numbersOfImages).map { imagePrefix + "\($0)" }
    }
}
