//
//  CurrencyConvertible.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 27.07.2025.
//

import Foundation

///Допустим ли такой нейминг протокола в этом конктесте
protocol CurrencyConvertible: AnyObject {
    var exchangeRates: [String: [ExchangeRate]] { get set }
    
    func setExchangeRates(_ rates: [ExchangeRate])
    func convert(from transaction: Transaction,
                 to currency: String) -> Double?
}

extension CurrencyConvertible {
    func setExchangeRates(_ rates: [ExchangeRate]) {
        exchangeRates = Dictionary(grouping: rates, by: \.from)
    }
}

final class CurrencyConverter: CurrencyConvertible {
    var exchangeRates: [String: [ExchangeRate]] = [:]
    
    init(exchangeRates: [ExchangeRate]) {
        setExchangeRates(exchangeRates)
    }
    
    /// Конвертирует сумму из одной валюты в другую.
    ///
    /// **Сложность:
    /// - В худшем случае O(n * m), где:
    ///   - n = количество курсов для `transaction.currency`
    ///   - m = количество курсов для промежуточной валюты (`rate.to`)
    /// - Это линейный поиск по двум массивам внутри словаря.
    func convert(from transaction: Transaction,
                 to currency: String) -> Double? {
        
        guard transaction.currency != currency else {
            return transaction.amount
        }
        
        for rate in exchangeRates[transaction.currency] ?? [] {
            
            if rate.to == currency {
                
                return transaction.amount * Double(rate.rate)
                
            } else if let bindingRate = bindingRate(of: rate,
                                                    for: currency) {
                
                let crossRate = rate.rate * bindingRate.rate
                return transaction.amount * Double(crossRate)
            }
        }
        
        return nil
    }
    
    private func bindingRate(of rate: ExchangeRate,
                             for currency: String) -> ExchangeRate? {
        
        for element in exchangeRates[rate.to] ?? [] {
            if element.to == currency {
                return element
            }
        }
        
        return nil
    }
}
