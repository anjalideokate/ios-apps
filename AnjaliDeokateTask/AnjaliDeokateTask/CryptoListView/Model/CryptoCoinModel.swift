//
//  Model.swift
//  AnjaliDeokateTask
//
//  Created by Anjali on 27/11/24.
//

import Foundation

enum CryptoType: String {
    case coin
    case token
    case unknown
}

struct Crypto: Codable {
    let name: String
    let symbol: String
    let isNew: Bool
    let isActive: Bool
    let type: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case symbol = "symbol"
        case isNew = "is_new"
        case isActive = "is_active"
        case type = "type"
    }

    var cryptoType: CryptoType {
        CryptoType(rawValue: type) ?? .unknown
    }

    var isToken: Bool {
        cryptoType == .token
    }

    var isCoin: Bool {
        cryptoType == .coin
    }

    var isActiveCoin: Bool {
        isCoin && isActive
    }
    
    var isInactiveCoin: Bool {
        isCoin && !isActive
    }
    
    var isNewCoin: Bool {
        isNew && isCoin
    }
}
