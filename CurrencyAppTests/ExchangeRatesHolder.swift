//
//  ExchangeRatesHolder.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 27.07.2025.
//

import Foundation
@testable import CurrencyApp

struct ExchangeRatesHolder {
    static let exchangeRates: [ExchangeRate] = [
        ExchangeRate(rate: 0.77, from: "USD", to: "GBP"),
        ExchangeRate(rate: 1.3, from: "GBP", to: "USD"),
        ExchangeRate(rate: 1.09, from: "USD", to: "CAD"),
        ExchangeRate(rate: 0.92, from: "CAD", to: "USD"),
        ExchangeRate(rate: 0.83, from: "GBP", to: "AUD"),
        ExchangeRate(rate: 1.2, from: "AUD", to: "GBP"),
    ]
}
