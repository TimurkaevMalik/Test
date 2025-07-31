//
//  EdgeInsets.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 31.07.2025.
//

import Foundation

struct EdgeInsets {
    let horizontal: HorizontalInsets
    let vertical: VerticalInsets
    
    init(horizontal: HorizontalInsets = HorizontalInsets(),
         vertical: VerticalInsets = VerticalInsets()) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
}
