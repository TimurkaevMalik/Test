//
//  ExchangeRateDTO.swift
//  Test
//
//  Created by Malik Timurkaev on 25.07.2025.
//

import Foundation

struct ExchangeRateDTO: Decodable {
    let rate: String
    let from: String
    let to: String
}

extension ExchangeRateDTO {
    func toDomain() -> ExchangeRate? {
        if let rate = Float(rate) {
            return ExchangeRate(rate: rate, from: from, to: to)
        }
        
        return nil
    }
}
