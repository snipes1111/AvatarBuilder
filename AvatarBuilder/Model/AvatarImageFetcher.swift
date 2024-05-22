//
//  AvatarImages.swift
//  AvatarBuilder
//
//  Created by user on 21/05/2024.
//

import Foundation
import UIKit

struct AvatarImageFetcher {
    private static let imagePrefix: String = "avatar"
    
    static func getAvatarImages(numbersOfImages: Int) -> [String] {
        (1...numbersOfImages).map { imagePrefix + "\($0)" }
    }
    
    static func getImageData(imageName: String) -> Data {
        let image = UIImage(named: imageName)
        guard let data = image?.pngData() else {
            print("No image data was produced")
            return Data()
        }
        return data
    }
}
