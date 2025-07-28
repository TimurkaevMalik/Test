//
//  AppCoordinator.swift
//  Test
//
//  Created by Malik Timurkaev on 25.07.2025.
//

import UIKit

@MainActor
protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
}

@MainActor
final class AppCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showProductListController()
    }
    
    private func showProductListController() {
        let controller = ProductItemsController()
        navigationController.pushViewController(controller, animated: true)
    }
}
