//
//  AvatarModel.swift
//  AvatarBuilder
//
//  Created by user on 22/05/2024.
//

import Foundation

struct Avatar: Codable {
    let image: Data
    let age: String
    let height: String
    let weight: String
}

extension Avatar {
    static let placeholder = Avatar(image: Data(), age: "0", height: "0", weight: "0")
}
