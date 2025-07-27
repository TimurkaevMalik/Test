//
//  TransactionsRepository.swift
//  Test
//
//  Created by Malik Timurkaev on 26.07.2025.
//

import Foundation

protocol TransactionsRepositoryProtocol {
    func fetchTransactions() async throws -> [Transaction]
}

final class PlistTransactionsRepository: TransactionsRepositoryProtocol {
    
    private let transactionsService: ResourceLoader
    private let resource: ResourceFile
    
    init(transactionsService: ResourceLoader,
         resource: ResourceFile) {
        self.transactionsService = transactionsService
        self.resource = resource
    }
    
    func fetchTransactions() async throws -> [Transaction] {
        
        let data: [TransactionDTO] = try await transactionsService.load(from: resource)
        return data.compactMap({ $0.toDomain() })
    }
}
