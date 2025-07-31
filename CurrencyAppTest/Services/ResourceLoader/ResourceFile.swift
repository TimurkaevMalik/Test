//
//  ResourceFile.swift
//  Test
//
//  Created by Malik Timurkaev on 25.07.2025.
//

import Foundation

/// Структура, представляющая локальный файл-ресурс в Bundle.
/// Используется для описания имени файла и его расширения в
/// типобезопасной форме, чтобы повысить читаемость при
/// загрузке ресурсов.
struct ResourceFile {
    let name: Name
    let fileExtension: Extension
}

extension ResourceFile {
    
    /// Доступные имена встроенных ресурсов.
    enum Name: String {
        case transactions
        case rates
        // Добавь сюда другие имена, если появятся новые ресурсы
    }
    
    /// Поддерживаемые расширения файлов.
    /// Предназначено для контроля форматов, доступных для загрузки
    /// (например, .plist, .json и т.д.)
    enum Extension: String {
        case plist
        // Можно расширить: case json, case txt, ...
    }
}
