//
//  ProductItemsControllerFactoryProtocol.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 29.07.2025.
//

import Foundation

@MainActor
protocol ProductItemsControllerFactoryProtocol {
#warning("почему наследник не наследует async аннотацию, и при вызове метода из @MainActor не приходится писать await")
    func make() async -> ProductItemsController
}

final class ProductItemsControllerFactory: ProductItemsControllerFactoryProtocol {
    
    func make() -> ProductItemsController {
        let plistService = DataPlistService()
        
        let transactionsResource = ResourceFile(
            name: .transactions,
            fileExtension: .plist)
        let ratesResource = ResourceFile(
            name: .rates,
            fileExtension: .plist)
        
        let productsRepository = PlistProductsRepository(
            productsService: plistService,
            resource: transactionsResource)
        let ratesRepository = PlistRatesRepository(
            ratesService: plistService,
            resource: ratesResource)
        
        let converter = CurrencyConverter()
        let useCase = FetchProductsUseCase(
            productsRepository: productsRepository,
            ratesRepository: ratesRepository,
            converter: converter)
        
        let vm = ProductItemsVM(fetchProductsUseCase: useCase)
        return ProductItemsController(productItemsVM: vm)
    }
}
