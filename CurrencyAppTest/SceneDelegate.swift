//
//  SceneDelegate.swift
//  Test
//
//  Created by Malik Timurkaev on 30.06.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: Coordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        let window = UIWindow(windowScene: windowScene)
        let navController = UINavigationController()
        appCoordinator = AppCoordinator(
            navigationController: navController,
            factory: ProductItemsControllerFactory())
        
        window.rootViewController = navController
        appCoordinator?.start()
        self.window = window
        window.makeKeyAndVisible()
    }
}
