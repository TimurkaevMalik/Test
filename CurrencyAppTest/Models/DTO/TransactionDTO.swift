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
