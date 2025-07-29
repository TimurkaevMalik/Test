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
    
    init(productsRepository: ProductsRepositoryProtocol,
         ratesRepository: RatesRepositoryProtocol,
         converter: CurrencyConverter) {
        
        self.productsRepository = productsRepository
        self.ratesRepository = ratesRepository
        self.converter = converter
    }
    
    func fetch() async throws -> [ProductItem] {
        let products: [Product] = try await productsRepository.fetchProducts()
        
        if await !converter.hasRates() {
            let rates = try await ratesRepository.fetchRates()
            await converter.setExchangeRates(rates)
        }

        return await makeProductItems(from: products)
    }
    
    private func makeProductItems(
        from products: [Product]
    ) async -> [ProductItem] {
        
        return await Task.detached(priority: .utility) {
            var items = [ProductItem]()
            
            for product in products {
                
                let transactionItems = await self.makeTransactionItems(from: product.transactions)
                
                let item = ProductItem(sku: product.sku,
                                       transactions: transactionItems)
                items.append(item)
            }
            
            return items
        }.value
    }
    
    private func makeTransactionItems(
        from transactions: [Transaction]
    ) async -> [TransactionItem] {
        
        return await Task.detached(priority: .utility) {
            
            var items = [TransactionItem]()
            
            for transaction in transactions {
                
                let amount = transaction.amount
                let currency = transaction.currency
                
                if let amountGBP = await self.converter.convert(
                    from: transaction, to: "GBP") {
                    
                    let item = TransactionItem(initialCurrency: currency,
                                               initialAmount: String(amount),
                                               amountGBP: String(amountGBP))
                    items.append(item)
                }
            }
            
            return items
        }.value
    }
}
