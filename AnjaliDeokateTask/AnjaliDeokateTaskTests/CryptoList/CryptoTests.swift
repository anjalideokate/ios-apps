//
//  CryptoTests.swift
//  AnjaliDeokateTaskTests
//
//  Created by Anjali on 02/12/24.
//

import XCTest
@testable import AnjaliDeokateTask

final class CryptoTests: XCTestCase {
    func testCryptoCoin() {
        let sut = MockCryptoDataProvider.getCryproActiveNewCoin()
        XCTAssertEqual(sut.name, "Name1")
        XCTAssertEqual(sut.symbol, "Symbol1")
        XCTAssertEqual(sut.cryptoType, .coin)
        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.isActiveCoin)
        XCTAssertTrue(sut.isCoin)
        XCTAssertFalse(sut.isInactiveCoin)
        XCTAssertTrue(sut.isNew)
        XCTAssertTrue(sut.isNewCoin)
        XCTAssertFalse(sut.isToken)
    }
    
    func testCryptoToken() {
        let sut = MockCryptoDataProvider.getCryproActivNewToken()
        XCTAssertEqual(sut.name, "Name3")
        XCTAssertEqual(sut.symbol, "Symbol3")
        XCTAssertEqual(sut.cryptoType, .token)
        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.isActiveCoin)
        XCTAssertFalse(sut.isCoin)
        XCTAssertFalse(sut.isInactiveCoin)
        XCTAssertTrue(sut.isNew)
        XCTAssertFalse(sut.isNewCoin)
        XCTAssertTrue(sut.isToken)
    }
}
