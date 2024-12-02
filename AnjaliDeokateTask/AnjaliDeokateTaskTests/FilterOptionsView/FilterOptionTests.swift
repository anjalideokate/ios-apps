//
//  FilterOptionTests.swift
//  AnjaliDeokateTaskTests
//
//  Created by Anjali on 01/12/24.
//

import XCTest
@testable import AnjaliDeokateTask

final class FilterOptionTests: XCTestCase {
    func testFilterOptionTitle() {
        let sut = MockCryptoDataProvider.getAllFilterOptions()
        for action in sut {
            switch action {
            case .activeCoins:
                XCTAssertEqual(action.title, "Active Coins")
            case .inactiveCoins:
                XCTAssertEqual(action.title,"Inactive Coins")
            case .onlyTokens:
                XCTAssertEqual(action.title,"Only Tokens")
            case .onlyCoins:
                XCTAssertEqual(action.title,"Only Coins")
            case .newCoins:
                XCTAssertEqual(action.title,"New Coins")
            }
        }
    }
}
