//
//  FilterOptionViewModelTests.swift
//  AnjaliDeokateTaskTests
//
//  Created by Anjali on 01/12/24.
//

import XCTest
@testable import AnjaliDeokateTask

class MockFilterResultDelegate: FilterResultDelegate {
    var shouldShowFilteredResult: Bool?
    var filteredResults: [Crypto]?

    func filterResult(shouldShowFilteredResult: Bool, filteredResults: [Crypto]) {
        self.shouldShowFilteredResult = shouldShowFilteredResult
        self.filteredResults = filteredResults
    }
}

final class FilterOptionViewModelTests: XCTestCase {
    func testInit() {
        let sut = FilterOptionViewModel(activeFilters: [.activeCoins],
                                        lastDisplayedList: [MockCryptoDataProvider.getCryproActivNewToken()])
        XCTAssertEqual(sut.testHooks.activeFilters, [.activeCoins])
        XCTAssertEqual(sut.filterOptions, [.activeCoins,
                                           .inactiveCoins,
                                           .onlyTokens,
                                           .onlyCoins,
                                           .newCoins])
        XCTAssertEqual(sut.lastDisplayedList.first?.name,
                       "Name3")
        XCTAssertEqual(sut.lastDisplayedList.first?.symbol,
                       "Symbol3")
        XCTAssertEqual(sut.lastDisplayedList.first?.cryptoType,
                       .token)
        XCTAssertTrue(sut.lastDisplayedList.first?.isActive == true)
        XCTAssertTrue(sut.lastDisplayedList.first?.isNew == true)
    }
    
    func testIsActionSelected() {
        let sut = FilterOptionViewModel(activeFilters: [],
                                        lastDisplayedList: [MockCryptoDataProvider.getCryproActivNewToken()])
        XCTAssertFalse(sut.isFilterSelected(.activeCoins))
        XCTAssertFalse(sut.isFilterSelected(.inactiveCoins))
        XCTAssertFalse(sut.isFilterSelected(.newCoins))
        XCTAssertFalse(sut.isFilterSelected(.onlyCoins))
        XCTAssertFalse(sut.isFilterSelected(.onlyTokens))
        sut.testHooks.upaateActiveFilter(with: [.activeCoins])
        XCTAssertTrue(sut.isFilterSelected(.activeCoins))
    }
    
    func testMultipleFilterSelectionDeselection() {
        let sut = FilterOptionViewModel(activeFilters: [],
                                        lastDisplayedList: [MockCryptoDataProvider.getCryproActiveNewCoin(),
                                                      MockCryptoDataProvider.getCryproInactiveCoin()])
        let mockDelegate = MockFilterResultDelegate()
        sut.delegate = mockDelegate
        
        XCTAssertEqual(sut.testHooks.filteredResults.count, 0)
        XCTAssertEqual(sut.lastDisplayedList.count, 2)
        sut.actionFor(.activeCoins)
        XCTAssertEqual(sut.testHooks.filteredResults.count, 1)
        XCTAssert(mockDelegate.shouldShowFilteredResult == true)
        XCTAssert(mockDelegate.filteredResults?.count == 1)
        sut.actionFor(.activeCoins)
        XCTAssertEqual(sut.testHooks.filteredResults.count, 0)
        XCTAssert(mockDelegate.shouldShowFilteredResult == false)
        XCTAssert(mockDelegate.filteredResults?.count == 0)
        sut.actionFor(.inactiveCoins)
        XCTAssertEqual(sut.testHooks.filteredResults.count, 1)
        XCTAssert(mockDelegate.shouldShowFilteredResult == true)
        XCTAssert(mockDelegate.filteredResults?.count == 1)
        sut.actionFor(.activeCoins)
        XCTAssertEqual(sut.testHooks.filteredResults.count, 2)
        XCTAssert(mockDelegate.shouldShowFilteredResult == true)
        XCTAssert(mockDelegate.filteredResults?.count == 2)
    }
    
    func testAllFilterSelected() {
        let sut = FilterOptionViewModel(activeFilters: [],
                                        lastDisplayedList: [MockCryptoDataProvider.getCryproActiveNewCoin(),
                                                            MockCryptoDataProvider.getCryproInactiveCoin(),
                                                            MockCryptoDataProvider.getCryproActivNewToken()])
        let mockDelegate = MockFilterResultDelegate()
        sut.delegate = mockDelegate
        
        XCTAssertEqual(sut.testHooks.filteredResults.count, 0)
        XCTAssertEqual(sut.lastDisplayedList.count, 3)
        sut.actionFor(.activeCoins)
        sut.actionFor(.inactiveCoins)
        sut.actionFor(.newCoins)
        sut.actionFor(.onlyCoins)
        sut.actionFor(.onlyTokens)
        XCTAssertEqual(sut.testHooks.filteredResults.count, 3)
        XCTAssert(mockDelegate.shouldShowFilteredResult == false)
        XCTAssert(mockDelegate.filteredResults?.count == 0)
    }
    
    func testNoFilterSelected() {
        let sut = FilterOptionViewModel(activeFilters: [.activeCoins],
                                        lastDisplayedList: [MockCryptoDataProvider.getCryproActiveNewCoin(),
                                                            MockCryptoDataProvider.getCryproInactiveCoin(),
                                                            MockCryptoDataProvider.getCryproActivNewToken()])
        let mockDelegate = MockFilterResultDelegate()
        sut.delegate = mockDelegate
        
        XCTAssertEqual(sut.testHooks.filteredResults.count, 0)
        XCTAssertEqual(sut.lastDisplayedList.count, 3)
        sut.actionFor(.activeCoins)
        XCTAssertEqual(sut.testHooks.filteredResults.count, 0)
        XCTAssert(mockDelegate.shouldShowFilteredResult == false)
        XCTAssert(mockDelegate.filteredResults?.count == 0)
    }
}
