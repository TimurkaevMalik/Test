//
//  AppCoordinator.swift
//  Test
//
//  Created by Malik Timurkaev on 25.07.2025.
//

import UIKit

@MainActor
protocol Coordinator {
    func start()
}

final class AppCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let productItemsControllerFactory: ProductItemsControllerFactoryProtocol
    
    init(navigationController: UINavigationController,
         factory: ProductItemsControllerFactoryProtocol) {
        self.navigationController = navigationController
        productItemsControllerFactory = factory
    }
    
    func start() {
        Task {
            await showProductListController()
        }
    }
    
    private func showProductListController() async {
        let controller = await productItemsControllerFactory.make()
        navigationController.pushViewController(controller,
                                                animated: true)
    }
}
