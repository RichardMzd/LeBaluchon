//
//  Translation.swift
//  LeBaluchon
//
//  Created by Richard Arif Mazid on 29/07/2022.
//

import Foundation

struct Translate: Codable {
    struct Data: Codable {
        let translations: [Translation]
        struct Translation: Codable {
            let translatedText: String
        }
    }
    let data: Data
}
