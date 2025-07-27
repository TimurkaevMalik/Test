//
//  RatesRepository.swift
//  Test
//
//  Created by Malik Timurkaev on 25.07.2025.
//

import Foundation

protocol RatesRepositoryProtocol {
    func fetchRates() async throws -> [Rate]
}

final class PlistRatesRepository: RatesRepositoryProtocol {
    
    private let ratesService: ResourceLoader
    private let resource: ResourceFile
    
    init(ratesService: ResourceLoader,
         resource: ResourceFile) {
        self.ratesService = ratesService
        self.resource = resource
    }
    
    func fetchRates() async throws -> [Rate] {
        
        let data: [RateDTO] = try await ratesService.load(from: resource)
        return data.compactMap({ $0.toDomain() })
    }
}
