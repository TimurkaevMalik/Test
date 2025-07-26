//
//  RatesPlistService.swift
//  Test
//
//  Created by Malik Timurkaev on 25.07.2025.
//

import Foundation

///Правильно ли я логирую ошибки? Не слишком много кода?

final class DataPlistService: ResourceLoader, Sendable {
    
    private let decoder = PropertyListDecoder()
    
    func load<T>(from id: ResourceID) async throws -> T
    where T: Decodable & Sendable {
        
        switch id {
        case .resource(let file):
            return try await load(from: file)
            
        default:
            throw ErrorPlistService.unsupportedResource
        }
    }
    
    private func load<T>(from file: ResourceFile) async throws -> T
    where T: Decodable & Sendable {
        
        return try await Task.detached(priority: .utility) {
            
            guard let url = self.resolveURL(for: file) else {
                throw ErrorPlistService.fileNotFound
            }
            
            do {
                let data = try Data(contentsOf: url)
                
                do {
                    return try self.decoder.decode(T.self,
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
        return Bundle.main.url(forResource: resource.name.rawValue,
                               withExtension: resource.fileExtension.rawValue)
    }
}
