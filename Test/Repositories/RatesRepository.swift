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

final class RatesRepository: RatesRepositoryProtocol {
    
    private let loaderService: ResourceLoader
    
    init(loaderService: ResourceLoader) {
        self.loaderService = loaderService
    }
    
    func fetchRates() async throws -> [Rate] {
        
        let resourceFile = ResourceFile(name: .rates,
                                        fileExtension: .plist)
        let data: [RateDTO] = try await loaderService.load(from: resourceFile)
        
        return data.compactMap({ $0.toDomain() })
    }
}
