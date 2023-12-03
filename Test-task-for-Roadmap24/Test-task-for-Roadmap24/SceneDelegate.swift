//
//  SceneDelegate.swift
//  Test-task-for-Roadmap24
//
//  Created by Наталья Владимировна Пофтальная on 25.11.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let applicationScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: applicationScene)
        let mainController = LaunchScreenViewController()
        window?.rootViewController = mainController
        window?.makeKeyAndVisible()
    }
    
}
