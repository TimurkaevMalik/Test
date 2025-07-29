//
//  Array+Ext.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 28.07.2025.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
