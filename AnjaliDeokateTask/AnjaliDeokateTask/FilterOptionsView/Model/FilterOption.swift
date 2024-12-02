//
//  FilterOption.swift
//  AnjaliDeokateTask
//
//  Created by Anjali on 30/11/24.
//

import Foundation

enum FilterOption: Equatable {
    case activeCoins
    case inactiveCoins
    case onlyTokens
    case onlyCoins
    case newCoins
    
    var title: String {
        switch self {
        case .activeCoins:
            "Active Coins"
        case .inactiveCoins:
            "Inactive Coins"
        case .onlyTokens:
            "Only Tokens"
        case .onlyCoins:
            "Only Coins"
        case .newCoins:
            "New Coins"
        }
    }
}
