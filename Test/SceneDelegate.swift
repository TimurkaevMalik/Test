//
//  SceneDelegate.swift
//  Test
//
//  Created by Malik Timurkaev on 30.06.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let appCoordinator = AppCoordinator(navigationController: UINavigationController())
        window.rootViewController = appCoordinator.navigationController
        appCoordinator.start()
        
        self.window = window
        window.makeKeyAndVisible()
    }
}
