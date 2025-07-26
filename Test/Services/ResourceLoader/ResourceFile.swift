//
//  ResourceFile.swift
//  Test
//
//  Created by Malik Timurkaev on 25.07.2025.
//

import Foundation

struct ResourceFile {
    let name: Name
    let fileExtension: Extension
}

extension ResourceFile {
    enum Name: String {
        case transactions
        case rates
    }
    
    enum Extension: String {
        case plist
    }
}
