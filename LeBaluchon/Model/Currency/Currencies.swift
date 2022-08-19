//
//  Currencies.swift
//  LeBaluchon
//
//  Created by Richard Arif Mazid on 17/08/2022.
//

import Foundation

enum Currencies {
    case euro
    case dollar
    
    var currenciesNames: String {
        switch self {
        case .euro:
            return "Euro € 🇪🇺"
        case .dollar:
            return "Dollar $ 🇺🇸"
        }
    }
    
    var currenciesKeys: String {
        switch self {
        case .euro:
            return "EUR"
        case .dollar:
            return "USD"
        }
    }
}
