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
        configureNavigationBar()
    }
    
    func start() {
        Task {
            await showProductListController()
        }
    }
    
    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .secondarySystemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func pushController(_ controller: UIViewController) {
        navigationController.pushViewController(controller,
                                                animated: true)
    }
}

private extension AppCoordinator {
    func showProductListController() async {
        let controller = await productItemsControllerFactory.make()
        
        controller.onProductSelected = { [weak self] productItem in
            self?.showTransactionItemsController(for: productItem)
        }
        pushController(controller)
    }
    
    func showTransactionItemsController(for item: ProductItem) {
        
        let viewModel = TransactionItemsVM(product: item)
        let controller = TransactionItemsController(transactionItemsVM: viewModel)
        pushController(controller)
    }
}
