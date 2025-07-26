//
//  DataServiceProtocol.swift
//  Test
//
//  Created by Malik Timurkaev on 25.07.2025.
//

import Foundation

/// Уникальный идентификатор ресурса, абстрагированный от конкретного источника.
/// Позволяет расширять поддержку типов ресурсов: локальные файлы, URL, ключи из БД и т.д.
enum ResourceID {
    case resource(file: ResourceFile)
}


/// Принимает универсальный `ResourceID`, что позволяет использовать как
/// локальные файлы, так и сетевые источники, БД и т.д., без изменения
/// интерфейса.
protocol ResourceLoader {
    func load<T: Decodable>(from id: ResourceID) async throws -> T
}
