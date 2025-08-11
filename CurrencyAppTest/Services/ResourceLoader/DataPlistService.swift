//
//  RatesPlistService.swift
//  Test
//
//  Created by Malik Timurkaev on 25.07.2025.
//

import Foundation

#warning("Правильно ли я логирую ошибки? Не слишком много кода для логирования?")
final class DataPlistService: ResourceLoader {
    
    private let bundle: Bundle
    
    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }
    
    func load<T>(from resource: ResourceFile) async throws -> T
    where T: Decodable & Sendable {
        
        return try await Task.detached(priority: .utility) {
            
            guard let url = self.resolveURL(for: resource) else {
                throw ErrorPlistService.fileNotFound
            }
            
            do {
                let data = try Data(contentsOf: url)
                
                do {
                    return try PropertyListDecoder().decode(T.self,
                                                            from: data)
                } catch {
                    throw ErrorPlistService.decoding
                }
            } catch {
                throw ErrorPlistService.reading
            }
        }.value
    }
    
    private func resolveURL(for resource: ResourceFile) -> URL? {
        return bundle.url(
            forResource: resource.name.rawValue,
            withExtension: resource.fileExtension.rawValue)
    }
}
