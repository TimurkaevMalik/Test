//
//  NumberFormatterProtocol.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 31.07.2025.
//

import Foundation

protocol NumberFormatterProtocol: Sendable {
    func currencySymbol(for code: String) -> String?
    func string(from: Double) -> String?
}

final class CustomNumberFormatter: NumberFormatterProtocol, Sendable {
    
    private let formatter = NumberFormatter()
    
    init() {
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.usesGroupingSeparator = true
        formatter.currencyGroupingSeparator = ","
        formatter.currencyDecimalSeparator = "."
    }
    
    func currencySymbol(for code: String) -> String? {
        if let baseSymbol = CurrencySymbol(code) {
            return baseSymbol.rawValue
        }
        formatter.currencyCode = code
        return formatter.currencySymbol
    }
    
    func string(from: Double) -> String? {
        formatter.string(from: from as NSNumber)
    }
}
