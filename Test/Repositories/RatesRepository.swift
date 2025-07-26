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
    private let resourceId: ResourceID
    
    init(ratesService: ResourceLoader) {
        self.ratesService = ratesService
        
        let resourceFile = ResourceFile(name: .rates, fileExtension: .plist)
        resourceId = ResourceID.resource(file: resourceFile)
    }
    
    func fetchRates() async throws -> [Rate] {
        
        let data: [RateDTO] = try await ratesService.load(from: resourceId)
        return data.compactMap({ $0.toDomain() })
    }
}
