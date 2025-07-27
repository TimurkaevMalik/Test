//
//  FetchProductsUseCase.swift
//  Test
//
//  Created by Malik Timurkaev on 27.07.2025.
//

import Foundation

//enum BaseCurrency: String {
//    case usd = "USD"
//    case gbp = "GBP"
//}

protocol ProductsFetchingUseCase {
    func fetchProducts() async throws -> [ProductItem]
}

final class FetchProductsUseCase: ProductsFetchingUseCase {
    
    private let productsRepository: ProductsRepositoryProtocol
    private let ratesRepository: RatesRepositoryProtocol
    private let converter: CurrencyConvertible
    
    init(productsRepository: ProductsRepositoryProtocol,
         ratesRepository: RatesRepositoryProtocol,
         converter: CurrencyConverter) {
        
        self.productsRepository = productsRepository
        self.ratesRepository = ratesRepository
        self.converter = converter
    }
    
    func fetchProducts() async throws -> [ProductItem] {
        let products = try await productsRepository.fetchProducts()
        
        if converter.exchangeRates.isEmpty {
            converter.exchangeRates = try await ratesRepository.fetchRates()
        }
        
        return []
    }
}
