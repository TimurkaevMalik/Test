//
//  CurrencyConverterTests.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 27.07.2025.
//

import XCTest
@testable import CurrencyApp

final class CurrencyConverterTests: XCTestCase {
        
    func testConvertSuccessfulCrossRate() async {
        let transaction = Transaction(currency: "USD", amount: 100)
        let rates = [ExchangeRate(rate: 0.77, from: "USD", to: "GBP"),
                     ExchangeRate(rate: 0.83, from: "GBP", to: "AUD")]
        
        let converter = CurrencyConverter()
        await converter.setExchangeRates(rates)
        let result = await converter.convert(from: transaction, to: "AUD")
        
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
   
    func testConvertSuccessfulWithoutCrossRate() async {
        let transaction = Transaction(currency: "USD", amount: 100)
        let rates = [ExchangeRate(rate: 0.77, from: "USD", to: "GBP")]
        
        let converter = CurrencyConverter()
        await converter.setExchangeRates(rates)
        let result = await converter.convert(from: transaction, to: "GBP")
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, 77, accuracy: 0.0001)
    }
    
    func testConvertSameCurrencyNoConversionNeeded() async {
        let transaction = Transaction(currency: "USD", amount: 100)
        
        let converter = CurrencyConverter()
        let result = await converter.convert(from: transaction, to: "USD")
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, transaction.amount)
    }
    
    func testConvertNoBindingRateReturnsNil() async {
        let transaction = Transaction(currency: "USD", amount: 100)
        
        let converter = CurrencyConverter()
        let result = await converter.convert(from: transaction, to: "GBP")
        
        XCTAssertNil(result)
    }
}
