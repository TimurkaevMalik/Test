//
//  TransactionsRepository.swift
//  Test
//
//  Created by Malik Timurkaev on 26.07.2025.
//

import Foundation

protocol ProductsRepositoryProtocol {
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
        return data.compactMap({ $0.toDomainProduct() })
    }
}
