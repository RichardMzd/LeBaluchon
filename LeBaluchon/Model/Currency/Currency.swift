//
//  Currency.swift
//  LeBaluchon
//
//  Created by Richard Arif Mazid on 12/08/2022.
//

import Foundation

struct Currency: Codable {
    let success: Bool
    let timestamp: Int
    let base: String
    let rates: Rates
}

// MARK: - Rates
struct Rates: Codable {
    let eur: Int
    let usd: Double

    enum CodingKeys: String, CodingKey {
        case eur = "EUR"
        case usd = "USD"
    }
}



