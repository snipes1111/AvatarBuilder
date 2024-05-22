//
//  UIView+Extensions.swift
//  AvatarBuilder
//
//  Created by user on 21/05/2024.
//

import UIKit

extension UIView {
    func fillSuperView(_ superView: UIView, isKeyboardSensetive: Bool = false) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        if isKeyboardSensetive {
            bottomAnchor.constraint(equalTo: superView.keyboardLayoutGuide.topAnchor).isActive = true
        } else {
            bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        }
    }
}
