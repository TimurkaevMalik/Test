//
//  ExchangeRateDTO.swift
//  Test
//
//  Created by Malik Timurkaev on 25.07.2025.
//

import Foundation

struct ExchangeRateDTO: Decodable {
    let rate: String
    let from: String
    let to: String
}
