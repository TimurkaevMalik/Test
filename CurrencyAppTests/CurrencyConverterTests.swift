//
//  CurrencyConverterTests.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 27.07.2025.
//

import XCTest
@testable import CurrencyApp

final class CurrencyConverterTests: XCTestCase {
    
    let rates: [ExchangeRate] = ExchangeRatesHolder.exchangeRates
    
    func testConvert_successfulCrossRate() {
        let transaction = Transaction(currency: "USD", amount: 100)
        let rates = [ExchangeRate(rate: 0.77, from: "USD", to: "GBP"),
                     ExchangeRate(rate: 0.83, from: "GBP", to: "AUD")]
        
        let converter = CurrencyConverter(exchangeRates: rates)
        let result = converter.convert(from: transaction, to: "AUD")
        
        XCTAssertNotNil(result)
        
        /// Формула кросс-курса:
        // USD → GBP = 0.77 (x/z)
        // GBP → AUD = 0.83 (z/y)
        // USD → AUD = ?    (x/y)
        // Формула: x/z * z/y = x/y
        // Вычисление курса: 0.77 * 0.83 ≈ 0.6391
        // Результат: 0.6391 * 100 ≈ 63.91
        XCTAssertEqual(result!, 63.91, accuracy: 0.0001)
    }
   
    func testConvert_successful_withoutCrossRate() {
        let transaction = Transaction(currency: "USD", amount: 100)
        let rates = [ExchangeRate(rate: 0.77, from: "USD", to: "GBP")]
        
        let converter = CurrencyConverter(exchangeRates: rates)
        let result = converter.convert(from: transaction, to: "GBP")
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, 77, accuracy: 0.0001)
    }
    
    func testConvert_sameCurrency_noConversionNeeded() {
        let transaction = Transaction(currency: "USD", amount: 100)
        
        let converter = CurrencyConverter(exchangeRates: [])
        let result = converter.convert(from: transaction, to: "USD")
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, transaction.amount)
    }
    
    func testConvert_noBindingRate_returnsNil() {
        let transaction = Transaction(currency: "USD", amount: 100)
        
        let converter = CurrencyConverter(exchangeRates: [])
        let result = converter.convert(from: transaction, to: "GBP")
        
        XCTAssertNil(result)
    }
}
