//
//  CurrencyConverter.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 27.07.2025.
//

import Foundation

#warning(" Допустим ли такой нейминг протокола в этом конктесте (окончание ible)?")

protocol CurrencyConvertible: AnyObject, Sendable {
    func setExchangeRates(_ rates: [ExchangeRate]) async
    func hasRates() async -> Bool
    func convert(from transaction: Transaction,
                 to targetCurrency: String) async -> Double?
}


final actor CurrencyConverter: CurrencyConvertible {
    private typealias From = String
    private typealias To = String
    private typealias Rate = Float
    
    private var exchangeRates: [From: [To: Rate]] = [:]
    
    func setExchangeRates(_ rates: [ExchangeRate]) async {
        exchangeRates = rates.reduce(into: [:], { result, rate in
            result[rate.from, default: [:]][rate.to] = rate.rate
        })
    }
    
    func hasRates() async -> Bool {
        !exchangeRates.isEmpty
    }
    
    /// Конвертирует сумму из одной валюты в другую, используя
    /// прямой или кросс-курс.
    ///
    /// - Note:
    ///   Метод сначала пытается найти прямой курс между
    ///   `transaction.currency` и `targetCurrency`.
    ///   Если прямого курса нет, он ищет кросс-курс через
    ///   промежуточную валюту:
    ///   `transaction.currency → промежуточная → targetCurrency`.
    ///
    /// - Complexity:
    ///   O(n), где `n` — количество доступных направлений конверсии из исходной валюты (`exchangeRates[from]`).
    ///   Все операции внутри цикла (сравнение ключа, lookup вложенного словаря) выполняются за O(1).
    ///
    func convert(from transaction: Transaction,
                 to targetCurrency: String) async -> Double? {
        
        guard transaction.currency != targetCurrency else {
            return transaction.amount
        }
        
        let from = transaction.currency
        
        for (intermediateCurrency, directRate) in exchangeRates[from] ?? [:] {
            
            if intermediateCurrency == targetCurrency {
                
                return transaction.amount * Double(directRate)
            }
            
            if let finalRate = rate(from: intermediateCurrency,
                                    to: targetCurrency) {
                
                let crossRate = directRate * finalRate
                return transaction.amount * Double(crossRate)
            }
        }
        
        return nil
    }
    
    /// - Complexity: O(1)
    private func rate(from: From, to: To) -> Float? {
        
        return exchangeRates[from]?[to]
    }
}
