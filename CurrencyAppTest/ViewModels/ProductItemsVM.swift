//
//  ProductItemsVMProtocol.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 28.07.2025.
//

import Foundation
import Combine

/// В компаниях дают ли такое сокращенное название (VM)
@MainActor
protocol ProductItemsVMProtocol {
    var productItems: [ProductItem] { get }
    var statePublisher: AnyPublisher<ProductItemsVMState, Never> { get }
    func fetchProductItems()
}

final class ProductItemsVM: ProductItemsVMProtocol {
    typealias State = ProductItemsVMState
    
    private let fetchProductsUseCase: ProductsFetchingUseCase
    private(set) var productItems: [ProductItem] = [] {
        didSet {
            statePublisherSubject.send(.loaded)
        }
    }
    
    private let statePublisherSubject = PassthroughSubject<State,
                                                           Never>()
    var statePublisher: AnyPublisher<State, Never> {
        statePublisherSubject.eraseToAnyPublisher()
    }
    
    init(fetchProductsUseCase: ProductsFetchingUseCase) {
        self.fetchProductsUseCase = fetchProductsUseCase
    }
    
    func fetchProductItems() {
        statePublisherSubject.send(.loading)
        
        Task(priority: .utility) {
            do {
                let items = try await fetchProductsUseCase.fetch()
                await MainActor.run {
                    productItems = items
                }
            } catch {
                await MainActor.run {
                    statePublisherSubject.send(.error(error))
                }
            }
        }
    }
}
