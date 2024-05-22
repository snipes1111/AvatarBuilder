//
//  UITextField+Extensions.swift
//  AvatarBuilder
//
//  Created by user on 21/05/2024.
//

import UIKit

extension UITextField {
    static func borderedTextField(with placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 5.0
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        return textField
    }
}
