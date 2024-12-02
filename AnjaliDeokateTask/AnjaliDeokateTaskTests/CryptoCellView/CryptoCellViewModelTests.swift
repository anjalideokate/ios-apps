//
//  CryptoCellViewModelTests.swift
//  AnjaliDeokateTaskTests
//
//  Created by Anjali on 01/12/24.
//

import XCTest
@testable import AnjaliDeokateTask

struct MockCryptoDataProvider {
    static func getAllFilterOptions() -> [FilterOption] {
        [FilterOption.activeCoins,
         FilterOption.inactiveCoins,
         FilterOption.newCoins,
         FilterOption.onlyCoins,
         FilterOption.onlyTokens]
    }
    
    static func getCryproActiveNewCoin() -> Crypto {
        Crypto(name: "Name1",
               symbol: "Symbol1",
               isNew: true,
               isActive: true,
               type: "coin")
    }
    
    static func getCryproInactiveCoin() -> Crypto {
        Crypto(name: "Name2",
               symbol: "Symbol2",
               isNew: false,
               isActive: false,
               type: "coin")
    }

    static func getCryproActivNewToken() -> Crypto {
        Crypto(name: "Name3",
               symbol: "Symbol3",
               isNew: true,
               isActive: true,
               type: "token")
    }
}

final class CryptoCellViewModelTests: XCTestCase {
    
    func testActiveNewCoin() {
        let sut = CryptoCellViewModel(crypto: MockCryptoDataProvider.getCryproActiveNewCoin())
        XCTAssertEqual(sut.title, "Name1")
        XCTAssertEqual(sut.subtitle, "Symbol1")
        XCTAssertTrue(sut.isNew)
        XCTAssertTrue(sut.isActive)
        XCTAssertEqual(sut.type, .coin)
        XCTAssertEqual(sut.imageIcon, .activeCoin)
        XCTAssertEqual(sut.newTagIcon, .newTag)
    }

    func testInactiveCoin() {
        let sut = CryptoCellViewModel(crypto: MockCryptoDataProvider.getCryproInactiveCoin())
        XCTAssertEqual(sut.title, "Name2")
        XCTAssertEqual(sut.subtitle, "Symbol2")
        XCTAssertFalse(sut.isNew)
        XCTAssertFalse(sut.isActive)
        XCTAssertEqual(sut.type, .coin)
        XCTAssertEqual(sut.imageIcon, .inactiveCoin)
        XCTAssertNil(sut.newTagIcon)
    }

    func testNewToken() {
        let sut = CryptoCellViewModel(crypto: MockCryptoDataProvider.getCryproActivNewToken())
        XCTAssertEqual(sut.title, "Name3")
        XCTAssertEqual(sut.subtitle, "Symbol3")
        XCTAssertTrue(sut.isNew)
        XCTAssertTrue(sut.isActive)
        XCTAssertEqual(sut.type, .token)
        XCTAssertEqual(sut.imageIcon, .token)
        XCTAssertEqual(sut.newTagIcon, .newTag)
    }
}
