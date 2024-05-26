//
//  SceneDelegate.swift
//  AvatarBuilder
//
//  Created by user on 20/05/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let rootVC = MainViewController()
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        window.backgroundColor = .white
        self.window = window
    }
}

