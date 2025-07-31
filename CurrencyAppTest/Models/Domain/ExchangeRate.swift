//
//  Rate.swift
//  Test
//
//  Created by Malik Timurkaev on 26.07.2025.
//

import Foundation

struct ExchangeRate {
    let rate: Float
    let from: String
    let to: String
}

extension ExchangeRate {
    init?(from dto: ExchangeRateDTO) {
        if let rateValue = Float(dto.rate) {
            rate = rateValue
            from = dto.from
            to = dto.to
        } else {
            return nil
        }
    }
}
