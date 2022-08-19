//
//  Languages.swift
//  LeBaluchon
//
//  Created by Richard Arif Mazid on 10/08/2022.
//

import Foundation

enum Languages {
    case french
    case english
    
    var languagesNames: String {
        switch self {
        case .french:
            return "Français 🇫🇷"
        case .english:
            return "Anglais 🇬🇧"
        }
    }
    
    var languagesKeys: String {
        switch self {
        case .french:
            return "fr"
        case .english:
            return "en"
        }
    }
}
