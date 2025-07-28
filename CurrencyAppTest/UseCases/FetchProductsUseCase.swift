//
//  FetchProductsUseCase.swift
//  Test
//
//  Created by Malik Timurkaev on 27.07.2025.
//

import Foundation

protocol ProductsFetchingUseCase {
    func fetchProducts() async throws -> [ProductItem]
}

final class FetchProductsUseCase: ProductsFetchingUseCase {
    
    private let productsRepository: ProductsRepositoryProtocol
    private let ratesRepository: RatesRepositoryProtocol
    private var converter: CurrencyConvertible
    
    init(productsRepository: ProductsRepositoryProtocol,
         ratesRepository: RatesRepositoryProtocol,
         converter: CurrencyConverter) {
        
        self.productsRepository = productsRepository
        self.ratesRepository = ratesRepository
        self.converter = converter
    }
    
    func fetchProducts() async throws -> [ProductItem] {
        let products: [Product] = try await productsRepository.fetchProducts()
        
        if converter.hasRates() {
            let rates = try await ratesRepository.fetchRates()
            converter.setExchangeRates(rates)
        }
   
        let result = products.map({
            
            let transactions = getTransactionItems($0.transactions)
            return ProductItem(sku: $0.sku,
                               transactions: transactions)
        })
        
        return []
    }
    
    private func getTransactionItems(
        _ transactions: [Transaction]
    ) -> [TransactionItem] {
        
        return transactions.compactMap({
            if let amountGBP = converter.convert(from: $0, to: "GBP") {
                
               return TransactionItem(initialCurrency: $0.currency,
                                      initialAmount: String($0.amount),
                                      amountGBP: String(amountGBP))
            } else {
                return nil
            }
        })
    }
}
