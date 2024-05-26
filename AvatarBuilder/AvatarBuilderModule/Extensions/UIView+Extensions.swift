//
//  UIView+Extensions.swift
//  AvatarBuilder
//
//  Created by user on 21/05/2024.
//

import UIKit

extension UIView {
    /// Places the view inside superview and anchor its constraints depending on the keyboard appearance possibility
    func fillSuperView(_ superView: UIView, isKeyboardSensetive: Bool = false) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        let topConstraint = topAnchor.constraint(equalTo: superView.topAnchor)
        if isKeyboardSensetive {
            topConstraint.priority = .defaultLow
            bottomAnchor.constraint(equalTo: superView.keyboardLayoutGuide.topAnchor).isActive = true
        } else {
            bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        }
        topConstraint.isActive = true
    }
}
