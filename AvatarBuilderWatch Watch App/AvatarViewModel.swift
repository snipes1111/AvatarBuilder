//
//  AvatarViewModel.swift
//  AvatarBuilderWatch Watch App
//
//  Created by user on 22/05/2024.
//

import Combine

class AvatarViewModel: ObservableObject {
    
    @Published var age: String = "25"
    @Published var height: String = "44"
    @Published var weight: String = "38"
    @Published var isEditing: Bool = false
    @Published var editedAttribute: AvatarAttribute = .age
    @Published var editedText: String = ""
    
    func getAttributeValue(for attribute: AvatarAttribute) -> String {
        switch attribute {
        case .age: return age
        case .height: return height
        case .weight: return weight
        }
    }
    
    func editAttribute(_ attribute: AvatarAttribute) {
        isEditing.toggle()
        editedAttribute = attribute
        let editedAttributeValue = getAttributeValue(for: attribute)
        editedText = editedAttributeValue
    }
    
    func confirmEditing() {
        switch editedAttribute {
        case .age: age = editedText
        case .height: height = editedText
        case .weight: weight = editedText
        }
        isEditing.toggle()
        editedText = ""
    }
}
