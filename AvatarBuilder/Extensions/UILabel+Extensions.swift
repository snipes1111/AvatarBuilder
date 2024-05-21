//
//  UILabel+Extensions.swift
//  AvatarBuilder
//
//  Created by user on 21/05/2024.
//

import UIKit

extension UILabel {
    static func createSectionLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func createAttributeLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 22)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }
}
