//
//  ProductItemsFactoryProtocol.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 30.07.2025.
//

import Foundation

protocol ProductItemsFactoryProtocol: Sendable {
    func make(from products: [Product],
              convertingCode: String) async -> [ProductItem]
}

final class ProductItemsFactory: ProductItemsFactoryProtocol {
    
    private let converter: CurrencyConvertible
    private let formatter: NumberFormatterProtocol
    
    init(converter: CurrencyConvertible,
         formatter: NumberFormatterProtocol) {
        self.converter = converter
        self.formatter = formatter
    }
    
    func make(
        from products: [Product],
        convertingCode: String
    ) async -> [ProductItem] {
        
        /// ConversionEnvironment создан,
        /// чтобы не плодить параметры в методах
        return await ConversionEnvironment
            .$convertingCode
            .withValue(convertingCode) {
                
                let result = await makeProductItems(from: products)
                return result
            }
    }
}

private extension ProductItemsFactory {
    func makeProductItems(
        from products: [Product]
    ) async -> [ProductItem] {
        
        await withTaskGroup(of: ProductItem.self) { group in
            
            for product in products {
                group.addTask {
                    
                    let transactionItems = await self.makeTransactionItems(from: product.transactions)
                    
                    let total = self.totalAmount(from:product.transactions)
                    
                    return ProductItem(sku: product.sku,
                                       total: total,
                                       transactions: transactionItems)
                }
            }
            
            return await group.reduce(into: [ProductItem]()) {
                $0.append($1)
            }
        }
    }
    
    func totalAmount(from transactions: [Transaction]) -> MoneyItem {
        
        let convertingCode = ConversionEnvironment.convertingCode
        let totalAmount = transactions.reduce(0) { $0 + $1.amount }
        
        if let symbol = formatter.currencySymbol(for: convertingCode),
           let formattedAmount = formatter.string(from: totalAmount) {
            
            return MoneyItem(amount: formattedAmount, currency: symbol)
        } else {
            return MoneyItem(amount: String(totalAmount), currency: "")
        }
    }
    
    func makeTransactionItems(
        from transactions: [Transaction]
    ) async -> [TransactionItem] {
        
        return await Task {
            
            var items = [TransactionItem]()
            
            for transaction in transactions {
                if let item = await self.makeTransactionItem(transaction) {
                    
                    items.append(item)
                }
            }
            
            return items
        }.value
    }
    
    func makeTransactionItem(
        _ transaction: Transaction
    ) async -> TransactionItem? {
        
        let convertingCode = ConversionEnvironment.convertingCode
        
        guard let newAmount = await self.converter.convert(
            from: transaction, to: convertingCode) else { return nil }
        
        let newTransaction = Transaction(currency: convertingCode,
                                         amount: newAmount)
        
        let initial = makeMoneyItem(from: transaction)
        let converted = makeMoneyItem(from: newTransaction)
        
        return TransactionItem(initial: initial,
                               converted: converted)
    }
    
    private func makeMoneyItem(
        from transaction: Transaction
    ) -> MoneyItem {
        
        if let formattedValue = formatter.string(from: transaction.amount),
           let currency = formatter.currencySymbol(for: transaction.currency)  {
            
            return MoneyItem(amount: formattedValue,
                             currency: currency)
        } else {
            
            return MoneyItem(amount: String(transaction.amount),
                             currency: transaction.currency)
        }
    }
}
