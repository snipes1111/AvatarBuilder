//
//  MainViewController+Extensions.swift
//  AvatarBuilder
//
//  Created by user on 21/05/2024.
//

import UIKit

extension MainViewController {
    
    func setupSubviews() {
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.addSubview(mainView)
        mainView.addSubview(chooseAvatarLabel)
        mainView.addSubview(setAttributesLabel)
        mainView.addSubview(imageCollectionView)
        // mainView constraints
        mainView.fillSuperView(view, isKeyboardSensetive: true)
        // chooseAvatarLabel constraints
        chooseAvatarLabel.topAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        chooseAvatarLabel.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        chooseAvatarLabel.widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 0.8).isActive = true
        // collectionView constraints
        setupCollectionViewConstraints()
        // attributesLabel constraints
        setAttributesLabel.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: 16).isActive = true
        setAttributesLabel.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        setAttributesLabel.widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 0.8).isActive = true
        // atrributesSection constraints
        setupAtrributesSection()
    }
    
    private func setupAtrributesSection() {
        let hStacks = createAttributeStackViews()
        let vStack = UIStackView(arrangedSubviews: hStacks)
        vStack.axis = .vertical
        vStack.distribution = .fillEqually
        vStack.spacing = 16
        vStack.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(vStack)
        vStack.topAnchor.constraint(equalTo: setAttributesLabel.bottomAnchor, constant: 24).isActive = true
        vStack.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        vStack.widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 0.8).isActive = true
        // avatarButton constraints
        mainView.addSubview(avatarButton)
        avatarButton.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 48).isActive = true
        avatarButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        avatarButton.widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 0.7).isActive = true
        avatarButton.heightAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 0.1).isActive = true
        avatarButton.bottomAnchor.constraint(lessThanOrEqualTo: mainView.bottomAnchor).isActive = true
    }
    
    private func createAttributeStackViews() -> [UIStackView] {
        let ageStackView = UIStackView(arrangedSubviews: [ageLabel, ageTF])
        let heightStackView = UIStackView(arrangedSubviews: [heightLabel, heightTF])
        let weightStackView = UIStackView(arrangedSubviews: [weightLabel, weightTF])
        let hStackViews = [ageStackView, heightStackView, weightStackView]
        hStackViews.forEach { $0.spacing = 16 }
        // setup TFs size
        [ageTF, heightTF, weightTF].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: mainView.bounds.width * 0.5).isActive = true
            $0.heightAnchor.constraint(equalToConstant: mainView.bounds.width * 0.1).isActive = true
        }
        return hStackViews
    }
    
    private func setupCollectionViewConstraints() {
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        imageCollectionView.leadingAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        imageCollectionView.trailingAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        imageCollectionView.topAnchor.constraint(equalTo: chooseAvatarLabel.bottomAnchor).isActive = true
        imageCollectionView.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 0.3).isActive = true
    }
}
