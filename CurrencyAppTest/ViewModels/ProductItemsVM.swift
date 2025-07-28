//
//  ProductItemsVMProtocol.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 28.07.2025.
//

import Foundation

/// В компаниях дают ли такое сокращенное название (VM)
@MainActor
protocol ProductItemsVMProtocol {
    func fetchProductItems()
}

final class ProductItemsVM: ProductItemsVMProtocol {
    
    private let fetchProductsUseCase: ProductsFetchingUseCase
    private var productItems: [ProductItem] = []
    
    init(fetchProductsUseCase: ProductsFetchingUseCase) {
        self.fetchProductsUseCase = fetchProductsUseCase
    }
    
    func fetchProductItems() {
        Task(priority: .utility) {
            productItems = try await fetchProductsUseCase.fetchProductItems()
        }
    }
}
