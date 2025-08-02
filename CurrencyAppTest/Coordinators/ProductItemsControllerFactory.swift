//
//  ProductItemsControllerFactoryProtocol.swift
//  CurrencyApp
//
//  Created by Malik Timurkaev on 29.07.2025.
//

import Foundation

@MainActor
protocol ProductItemsControllerFactoryProtocol {
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
        
#warning("нету ли нарушения архитектуры? Ведь я передаю converter в factory и usecase. Но модифицирую его содержимое только в usecase, то-есть вызываю его методы: hasRates(), setExchangeRates(). А метод convert() вызываю внутри factory")
        
        let converter = CurrencyConverter()
        let formatter = CustomNumberFormatter()
        let factory = ProductItemsFactory(converter: converter,
                                          formatter: formatter)
        
        let useCase = FetchProductsUseCase(
            productsRepository: productsRepository,
            ratesRepository: ratesRepository,
            converter: converter,
            factory: factory
        )
        
        let vm = ProductItemsVM(fetchProductsUseCase: useCase)
        return ProductItemsController(productItemsVM: vm)
    }
}
