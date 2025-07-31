//
//  FetchProductsUseCase.swift
//  Test
//
//  Created by Malik Timurkaev on 27.07.2025.
//

import Foundation

protocol ProductsFetchingUseCase: Sendable {
    func fetch() async throws -> [ProductItem]
}

@MainActor
final class FetchProductsUseCase: ProductsFetchingUseCase {
    
    private let productsRepository: ProductsRepositoryProtocol
    private let ratesRepository: RatesRepositoryProtocol
    private let converter: CurrencyConvertible
    private let productItemsFactory: ProductItemsFactoryProtocol
    
    init(productsRepository: ProductsRepositoryProtocol,
         ratesRepository: RatesRepositoryProtocol,
         converter: CurrencyConverter,
         factory: ProductItemsFactoryProtocol) {
        
        self.productsRepository = productsRepository
        self.ratesRepository = ratesRepository
        self.converter = converter
        productItemsFactory = factory
    }
    
    func fetch() async throws -> [ProductItem] {
        let products: [Product] = try await productsRepository.fetchProducts()
        
        if await !converter.hasRates() {
            let rates = try await ratesRepository.fetchRates()
            await converter.setExchangeRates(rates)
        }
        
        return await productItemsFactory.make(from: products,
                                              convertingCode: "GBP")
    }
}
