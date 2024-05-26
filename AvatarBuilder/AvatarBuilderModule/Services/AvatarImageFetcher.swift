//
//  AvatarImages.swift
//  AvatarBuilder
//
//  Created by user on 21/05/2024.
//

import Foundation
import UIKit

struct AvatarImageFetcher {
    /// Base prefix for the image name inside the project's Assets catalogue
    private static let imagePrefix: String = "avatar"
    /// Depending on the image count, provide an array of all image names inside the project's Assets catalogue
    static func getAvatarImages(numbersOfImages: Int) -> [String] {
        (1...numbersOfImages).map { imagePrefix + "\($0)" }
    }
    /// Depenging on the name of the image return Data object
    static func getImageData(imageName: String) -> Data {
        let image = UIImage(named: imageName)
        guard let data = image?.pngData() else {
            print("No image data was produced")
            return Data()
        }
        return data
    }
}
