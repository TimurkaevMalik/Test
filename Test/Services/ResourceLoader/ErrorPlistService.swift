//
//  ErrorPlistService.swift
//  Test
//
//  Created by Malik Timurkaev on 26.07.2025.
//

import Foundation

enum ErrorPlistService: Error {
    case fileNotFound
    case reading
    case decoding
    case unsupportedResource
}
