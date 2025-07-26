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
    func toDomain() -> Transaction? {
        if let amount = Double(amount) {
            return Transaction(amount: amount, currency: currency, sku: sku)
        }
        
        return nil
    }
}
