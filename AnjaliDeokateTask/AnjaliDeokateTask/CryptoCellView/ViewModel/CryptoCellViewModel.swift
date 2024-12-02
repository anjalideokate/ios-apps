//
//  CryptoCellViewModel.swift
//  AnjaliDeokateTask
//
//  Created by Anjali on 28/11/24.
//

import UIKit

class CryptoCellViewModel {
    let title: String
    let subtitle: String
    let type: CryptoType
    let isNew: Bool
    let isActive: Bool
    
    init(crypto: Crypto) {
        self.title = crypto.name
        self.subtitle = crypto.symbol
        self.type = crypto.cryptoType
        self.isNew = crypto.isNew
        isActive = crypto.isActive
    }
    
    var imageIcon : UIImage {
        switch type {
        case .coin:
            isActive ? .activeCoin : .inactiveCoin
        case .token:
            .token
        case .unknown:
            .checkmark
        }
    }

    var newTagIcon: UIImage? {
        isNew ? .newTag : nil
    }
}
