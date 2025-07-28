//
//  TransactionsRepository.swift
//  Test
//
//  Created by Malik Timurkaev on 26.07.2025.
//

import Foundation

protocol ProductsRepositoryProtocol: Sendable {
    func fetchProducts() async throws -> [Product]
}

final class PlistProductsRepository: ProductsRepositoryProtocol {
    
    private let productsService: ResourceLoader
    private let resource: ResourceFile
    
    init(productsService: ResourceLoader,
         resource: ResourceFile) {
        self.productsService = productsService
        self.resource = resource
    }
    
    func fetchProducts() async throws -> [Product] {
        
        let data: [TransactionDTO] = try await productsService.load(from: resource)
        
        let reduced: [String:[Transaction]] = data.reduce(into: [:]) {
            
            if let amount = Double($1.amount) {
                let transaction = Transaction(currency: $1.currency,
                                              amount: amount)
                $0[$1.sku, default: []].append(transaction)
            }
        }
        
        return reduced.map({ Product(sku: $0.key, transactions: $0.value) })
    }
}
