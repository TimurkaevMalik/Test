//
//  RatesRepository.swift
//  Test
//
//  Created by Malik Timurkaev on 25.07.2025.
//

import Foundation

protocol RatesRepositoryProtocol: Sendable {
    func fetchRates() async throws -> [ExchangeRate]
}

final class PlistRatesRepository: RatesRepositoryProtocol {
    
    private let ratesService: ResourceLoader
    private let resource: ResourceFile
    
    init(ratesService: ResourceLoader,
         resource: ResourceFile) {
        self.ratesService = ratesService
        self.resource = resource
    }
    
    func fetchRates() async throws -> [ExchangeRate] {
        
        let data: [ExchangeRateDTO] = try await ratesService.load(from: resource)
        return data.compactMap({ $0.toDomain() })
    }
}
