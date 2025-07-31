//
//  CurrencySymbol.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 31.07.2025.
//

import Foundation

#warning("Не является ли проблемой, если держать enum в папке с названием ModelsDomain?")

enum CurrencySymbol: String {
    case usd = "$"
    case gbp = "£"
    
    init?(_ rawValue: String) {
        switch rawValue.uppercased() {
        case "USD": self = .usd
        case "GBP": self = .gbp
        default: return nil
        }
    }
}
