//
//  ProductItemsFactoryProtocol.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 30.07.2025.
//

import Foundation

protocol ProductItemsFactoryProtocol: Sendable {
    func make(from products: [Product]) async -> [ProductItem]
}

final class ProductItemsFactory: ProductItemsFactoryProtocol {
    
    private let converter: CurrencyConvertible
    
    init(converter: CurrencyConvertible) {
        self.converter = converter
    }
    
    func make(from products: [Product]) async -> [ProductItem] {
        await makeProductItems(from: products)
    }
    
    private func makeProductItems(
        from products: [Product]
    ) async -> [ProductItem] {
        
        return await Task.detached(priority: .utility) {
            var items = [ProductItem]()
            
            for product in products {
                
                let transactionItems = await self.makeTransactionItems(from: product.transactions)
                
                let item = ProductItem(
                    sku: product.sku,
                    total: MoneyItem(amount: "", currency: ""),
                    transactions: transactionItems)
                
                items.append(item)
            }
            
            return items
        }.value
    }
    
    private func makeTransactionItems(
        from transactions: [Transaction]
    ) async -> [TransactionItem] {
        
        return await Task.detached(priority: .userInitiated) {
            
            var items = [TransactionItem]()
            
            for transaction in transactions {
                if let item = await self.makeTransactionItem(transaction) {
                    
                    items.append(item)
                }
            }
            
            return items
        }.value
    }
    
#warning("nonisolated метод, но использует actor")
    nonisolated
    private func makeTransactionItem(_ transaction: Transaction) async -> TransactionItem? {
        
        let amount = transaction.amount
        let currency = transaction.currency
        let newCurrency = "GBP"
        
        if let newAmount = await self.converter.convert(
            from: transaction, to: newCurrency) {
            
            let initial = MoneyItem(
                amount: String(amount),
                currency: currency)
            
            let converted = MoneyItem(
                amount: String(newAmount),
                currency: newCurrency)
            
            return TransactionItem(
                initial: initial,
                converted: converted)
        } else {
            return nil
        }
    }
}
