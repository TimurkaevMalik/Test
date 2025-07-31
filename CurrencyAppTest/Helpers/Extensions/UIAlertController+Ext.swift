//
//  Untitled.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 29.07.2025.
//

import UIKit

extension UIAlertController {
    func addActions(_ actions: [UIAlertAction]) {
        actions.forEach {
            addAction($0)
        }
    }
}

