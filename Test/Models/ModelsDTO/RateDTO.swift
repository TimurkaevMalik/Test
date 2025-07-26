//
//  RateDTO.swift
//  Test
//
//  Created by Malik Timurkaev on 25.07.2025.
//

import Foundation

struct RateDTO: Decodable {
    let rate: String
    let from: String
    let to: String
}

extension RateDTO {
    func toDomain() -> Rate? {
        if let rate = Float(rate) {
            return Rate(rate: rate, from: from, to: to)
        }
        
        return nil
    }
}
