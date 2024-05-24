//
//  AvatarModel.swift
//  AvatarBuilder
//
//  Created by user on 22/05/2024.
//

import Foundation

struct Avatar: Codable {
    var image: Data
    var age: String
    var height: String
    var weight: String
}

extension Avatar {
    static let placeholder = Avatar(image: Data(), age: "0", height: "0", weight: "0")
    
    static func encode(_ avatar: Avatar) -> [String: Any]? {
        guard
            let avatarData = try? JSONEncoder().encode(avatar),
            let avatarDictionary = try? JSONSerialization.jsonObject(with: avatarData, options: .allowFragments) as? [String: Any]
        else {
            print("Error to update application context")
            return nil
        }
        return avatarDictionary
    }
    
    static func decode(_ avatarDictionary: [String: Any]) -> Avatar? {
        guard let avatarData = try? JSONSerialization.data(withJSONObject: avatarDictionary, options: .fragmentsAllowed)
        else {
            print("Error to recieve context")
            return nil
        }
        do {
            let avatar = try JSONDecoder().decode(Avatar.self, from: avatarData)
            return avatar
        } catch {
            print("Error to decode data on wathes")
            return nil
        }
    }
}
