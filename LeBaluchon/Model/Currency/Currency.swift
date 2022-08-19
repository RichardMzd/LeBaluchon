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
    let base, date: String?
    let rates: Rates?
}

struct Rates: Codable {
    let usd: Double

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}
