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
    private let resourceId: ResourceID
    
    init(transactionsService: ResourceLoader) {
        self.transactionsService = transactionsService
        
        let resourceFile = ResourceFile(name: .transactions,
                                        fileExtension: .plist)
        resourceId = ResourceID.resource(file: resourceFile)
    }
    
    func fetchTransactions() async throws -> [Transaction] {
        
        let data: [TransactionDTO] = try await transactionsService.load(from: resourceId)
        return data.compactMap({ $0.toDomain() })
    }
}
