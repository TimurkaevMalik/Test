//
//  TransactionDTO.swift
//  Test
//
//  Created by Malik Timurkaev on 26.07.2025.
//

import Foundation

struct TransactionDTO: Decodable {
    let amount: String
    let currency: String
    let sku: String
}

extension TransactionDTO {
    func toDomainProduct() -> Product? {
        if let amount = Double(amount) {
            return Product(sku: sku,
                           transaction: Transaction(currency: currency,
                                                    amount: amount))
        }
        
        return nil
    }
}
