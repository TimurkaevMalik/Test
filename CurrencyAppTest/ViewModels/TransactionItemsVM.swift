//
//  TransactionsVMProtocol.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 29.07.2025.
//

import Foundation
/// Не является лишним этот viewModel? может мне стоило добавить массив сразу в контроллер? 
@MainActor
protocol TransactionItemsVMProtocol {
    var productItem: ProductItem { get }
}

final class TransactionItemsVM: TransactionItemsVMProtocol {
    let productItem: ProductItem
    
    init(product: ProductItem) {
        productItem = product
    }
}
