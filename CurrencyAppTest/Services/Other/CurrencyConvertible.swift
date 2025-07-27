//
//  CurrencyConvertible.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 27.07.2025.
//

import Foundation

///Допустим ли такой нейминг протокола в этом конктесте
protocol CurrencyConvertible: AnyObject {
    var exchangeRates: [ExchangeRate] { get set }
    
    func convert(from transaction: Transaction,
                 to currency: String) -> Double?
}

final class CurrencyConverter: CurrencyConvertible {
    var exchangeRates: [ExchangeRate]
    
    init(exchangeRates: [ExchangeRate] = []) {
        self.exchangeRates = exchangeRates
    }
    
    func convert(from transaction: Transaction,
                 to currency: String) -> Double? {
        
        guard transaction.currency != currency else {
            return transaction.amount
        }
        
        for rate in exchangeRates {
            
            if rate.from == transaction.currency {
                
                if rate.to == currency {
                    
                    return transaction.amount * Double(rate.rate)
                    
                } else if let bindingRate = bindingRate(of: rate,
                                                        for: currency) {
                    
                    let xAmount = transaction.amount
                    let crossRate = rate.rate * bindingRate.rate
                    
                    return transaction.amount * Double(crossRate)
                }
            }
        }
        
        return nil
    }
    
    private func bindingRate(of rate: ExchangeRate, for currency: String) -> ExchangeRate? {
        exchangeRates.first(where: {
            $0.from == rate.to && $0.to == currency
        })
    }
}
