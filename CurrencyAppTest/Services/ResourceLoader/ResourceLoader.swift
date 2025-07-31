//
//  DataServiceProtocol.swift
//  Test
//
//  Created by Malik Timurkaev on 25.07.2025.
//

import Foundation

protocol ResourceLoader: Sendable {
    func load<T: Decodable>(from resource: ResourceFile) async throws -> T
}
