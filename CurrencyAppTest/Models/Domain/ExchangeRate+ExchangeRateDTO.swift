//
//  Untitled.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 02.08.2025.
//

import Foundation

extension ExchangeRate {
    init?(dto: ExchangeRateDTO) {
        if let rateValue = Float(dto.rate) {
            rate = rateValue
            from = dto.from
            to = dto.to
        } else {
            return nil
        }
    }
}

