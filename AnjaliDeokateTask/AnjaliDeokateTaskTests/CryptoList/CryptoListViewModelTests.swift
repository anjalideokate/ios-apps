//
//  CryptoListViewModelTests.swift
//  AnjaliDeokateTaskTests
//
//  Created by Anjali on 02/12/24.
//

import XCTest
@testable import AnjaliDeokateTask

class MockCryptoListViewDelegate: CryptoListViewDelegate {
    var didReloadTableView = XCTestExpectation()
    var didShowLoader = XCTestExpectation()
    var didHideLoader = XCTestExpectation()
    var didShowFilterOptionsViewView = XCTestExpectation()
    var didShowError = XCTestExpectation()
    var errorType: ErrorType?
    var didHideError = XCTestExpectation()
    
    func reloadTableView() {
        didReloadTableView.fulfill()
    }

    func showLoader() {
        didShowLoader.fulfill()
    }
    func hideLoader() {
        didHideLoader.fulfill()
    }
    func showFilterOptionsViewView() {
        didShowFilterOptionsViewView.fulfill()
    }
    func showError(errorType: ErrorType) {
        self.errorType = errorType
        didShowError.fulfill()
    }
    func hideError() {
        didHideError.fulfill()
    }
}

final class CryptoListViewModelTests: XCTestCase {
    func testInit() {
        let sut = CryptoListViewModel()
        XCTAssertEqual(sut.activeFilters, [])
        XCTAssertEqual(sut.displayedCryptoList.count, 0)
        XCTAssertEqual(sut.testHooks.searchQuery, "")
        XCTAssertEqual(sut.testHooks.cryptoList.count, 0)
        XCTAssertEqual(sut.testHooks.filteredResult.count, 0)
    }
    
    func testSetupBindings() {
        let mockViewDelegate = MockCryptoListViewDelegate()
        let sut = CryptoListViewModel()
        sut.viewDelegate = mockViewDelegate
        sut.displayedCryptoList = []
        mockViewDelegate.didReloadTableView.expectedFulfillmentCount = 1
        mockViewDelegate.didHideLoader.expectedFulfillmentCount = 1
        wait(for: [mockViewDelegate.didReloadTableView])
        wait(for: [mockViewDelegate.didHideLoader])
    }
    
    func testEmptySearchResultWhenNoFilterOptionsAreNotSelected() {
        
    }
    
    func testNonEmptySearchResultWhenNoFilterOptionsAreNotSelected() {
        
    }
    

    func testEmptySearchQueryWhenFilterOptionsAreSelected() {
        
    }
    
    func testNonEmptySearchQueryWhenFilterOptionsAreSelected() {
        
    }
    
    func testEmptySearchQueryWithoutFilter() {
        let sut = CryptoListViewModel()
        let mockViewDelegate = MockCryptoListViewDelegate()
        sut.viewDelegate = mockViewDelegate
        mockViewDelegate.didReloadTableView.expectedFulfillmentCount = 2
        mockViewDelegate.didHideLoader.expectedFulfillmentCount = 2
        sut.testHooks.updateCryptoList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                                MockCryptoDataProvider.getCryproActiveNewCoin(),
                                                MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.testHooks.updateDisplayedList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                                MockCryptoDataProvider.getCryproActiveNewCoin(),
                                                MockCryptoDataProvider.getCryproInactiveCoin()])
        
        sut.filterContentForSearchText("")
        wait(for: [mockViewDelegate.didReloadTableView])
        wait(for: [mockViewDelegate.didHideLoader])
        XCTAssertEqual(sut.displayedCryptoList.count, 3)
    }
    
    func testEmptySearchQueryWithFilter() {
        let sut = CryptoListViewModel()
        let mockViewDelegate = MockCryptoListViewDelegate()
        sut.viewDelegate = mockViewDelegate
        mockViewDelegate.didReloadTableView.expectedFulfillmentCount = 2
        mockViewDelegate.didHideLoader.expectedFulfillmentCount = 2
        sut.testHooks.updateCryptoList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                                MockCryptoDataProvider.getCryproActiveNewCoin(),
                                                MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.testHooks.updateDisplayedList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                                MockCryptoDataProvider.getCryproActiveNewCoin(),
                                                MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.testHooks.updateFilterResult(activeFilters: [.activeCoins],
                                         filteredList: [MockCryptoDataProvider.getCryproActiveNewCoin()])
        
        sut.filterContentForSearchText("")
        wait(for: [mockViewDelegate.didReloadTableView])
        wait(for: [mockViewDelegate.didHideLoader])
        XCTAssertEqual(sut.displayedCryptoList.count, 1)
    }
    
    func testSearchCryptoNameWithoutFilter() {
        let sut = CryptoListViewModel()
        let mockViewDelegate = MockCryptoListViewDelegate()
        sut.viewDelegate = mockViewDelegate
        mockViewDelegate.didReloadTableView.expectedFulfillmentCount = 2
        mockViewDelegate.didHideLoader.expectedFulfillmentCount = 2
        sut.testHooks.updateCryptoList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                                MockCryptoDataProvider.getCryproActiveNewCoin(),
                                                MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.testHooks.updateDisplayedList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                                MockCryptoDataProvider.getCryproActiveNewCoin(),
                                                MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.filterContentForSearchText("Name2")
        wait(for: [mockViewDelegate.didReloadTableView])
        wait(for: [mockViewDelegate.didHideLoader])
        XCTAssertEqual(sut.displayedCryptoList.count, 1)
    }
    
    func testSearchCryptoNameWithFilter() {
        let sut = CryptoListViewModel()
        let mockViewDelegate = MockCryptoListViewDelegate()
        sut.viewDelegate = mockViewDelegate
        mockViewDelegate.didReloadTableView.expectedFulfillmentCount = 2
        mockViewDelegate.didHideLoader.expectedFulfillmentCount = 2
        sut.testHooks.updateCryptoList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                                MockCryptoDataProvider.getCryproActiveNewCoin(),
                                                MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.testHooks.updateDisplayedList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                                MockCryptoDataProvider.getCryproActiveNewCoin(),
                                                MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.testHooks.updateFilterResult(activeFilters: [.activeCoins],
                                         filteredList: [MockCryptoDataProvider.getCryproActiveNewCoin()])
        sut.filterContentForSearchText("Name2")
        wait(for: [mockViewDelegate.didReloadTableView])
        wait(for: [mockViewDelegate.didHideLoader])
        wait(for: [mockViewDelegate.didShowError])
        XCTAssertEqual(mockViewDelegate.errorType, .emptySearchResult)
    }
    
    func testSearchCryptoSymbolWithoutFilter() {
        let sut = CryptoListViewModel()
        let mockViewDelegate = MockCryptoListViewDelegate()
        sut.viewDelegate = mockViewDelegate
        mockViewDelegate.didReloadTableView.expectedFulfillmentCount = 2
        mockViewDelegate.didHideLoader.expectedFulfillmentCount = 2
        sut.testHooks.updateCryptoList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                                MockCryptoDataProvider.getCryproActiveNewCoin(),
                                                MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.testHooks.updateDisplayedList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                                MockCryptoDataProvider.getCryproActiveNewCoin(),
                                                MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.filterContentForSearchText("Symbol")
        wait(for: [mockViewDelegate.didReloadTableView])
        wait(for: [mockViewDelegate.didHideLoader])
        XCTAssertEqual(sut.displayedCryptoList.count, 3)
    }
    
    func testSearchCryptoSymbolFilter() {
        let sut = CryptoListViewModel()
        let mockViewDelegate = MockCryptoListViewDelegate()
        sut.viewDelegate = mockViewDelegate
        mockViewDelegate.didReloadTableView.expectedFulfillmentCount = 2
        mockViewDelegate.didHideLoader.expectedFulfillmentCount = 2
        sut.testHooks.updateCryptoList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                                MockCryptoDataProvider.getCryproActiveNewCoin(),
                                                MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.testHooks.updateDisplayedList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                                MockCryptoDataProvider.getCryproActiveNewCoin(),
                                                MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.testHooks.updateFilterResult(activeFilters: [.activeCoins],
                                         filteredList: [MockCryptoDataProvider.getCryproActiveNewCoin()])
        sut.filterContentForSearchText("Symbol")
        wait(for: [mockViewDelegate.didReloadTableView])
        wait(for: [mockViewDelegate.didHideLoader])
        XCTAssertEqual(sut.displayedCryptoList.count, 1)
    }
    
    
    func testEmptySearchResult() {
        let sut = CryptoListViewModel()
        let mockViewDelegate = MockCryptoListViewDelegate()
        sut.viewDelegate = mockViewDelegate
        mockViewDelegate.didReloadTableView.expectedFulfillmentCount = 2
        mockViewDelegate.didHideLoader.expectedFulfillmentCount = 2
        sut.testHooks.updateCryptoList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                              MockCryptoDataProvider.getCryproActiveNewCoin(),
                                              MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.testHooks.updateDisplayedList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                                 MockCryptoDataProvider.getCryproActiveNewCoin(),
                                                 MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.filterContentForSearchText("Random")
        wait(for: [mockViewDelegate.didReloadTableView])
        wait(for: [mockViewDelegate.didHideLoader])
        wait(for: [mockViewDelegate.didShowError])
        XCTAssertEqual(mockViewDelegate.errorType, .emptySearchResult)
    }
    
    func testSelectFilterOptionWithoutSearch() {
        let sut = CryptoListViewModel()
        let mockViewDelegate = MockCryptoListViewDelegate()
        sut.viewDelegate = mockViewDelegate
        mockViewDelegate.didReloadTableView.expectedFulfillmentCount = 2
        mockViewDelegate.didHideLoader.expectedFulfillmentCount = 2
        sut.testHooks.updateCryptoList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                              MockCryptoDataProvider.getCryproActiveNewCoin(),
                                              MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.testHooks.updateDisplayedList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                                 MockCryptoDataProvider.getCryproActiveNewCoin(),
                                                 MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.filterResult(shouldShowFilteredResult: true,
                         filteredResults: [MockCryptoDataProvider.getCryproActiveNewCoin()])
        wait(for: [mockViewDelegate.didReloadTableView])
        wait(for: [mockViewDelegate.didHideLoader])
        wait(for: [mockViewDelegate.didHideError])
        XCTAssertEqual(sut.displayedCryptoList.count, 1)
    }
    
    func testSelectFilterOptionWithSearch() {
        let sut = CryptoListViewModel()
        let mockViewDelegate = MockCryptoListViewDelegate()
        sut.viewDelegate = mockViewDelegate
        mockViewDelegate.didReloadTableView.expectedFulfillmentCount = 3
        mockViewDelegate.didHideLoader.expectedFulfillmentCount = 3
        sut.testHooks.updateCryptoList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                              MockCryptoDataProvider.getCryproActiveNewCoin(),
                                              MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.testHooks.updateDisplayedList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                                 MockCryptoDataProvider.getCryproActiveNewCoin(),
                                                 MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.filterContentForSearchText("Name1")

        sut.filterResult(shouldShowFilteredResult: true,
                         filteredResults: [MockCryptoDataProvider.getCryproActiveNewCoin()])
        wait(for: [mockViewDelegate.didReloadTableView])
        wait(for: [mockViewDelegate.didHideLoader])
        wait(for: [mockViewDelegate.didHideError])
        XCTAssertEqual(sut.displayedCryptoList.count, 1)
    }
    
    func testSelectFilterOptionEmptyResultWithSearch() {
        let sut = CryptoListViewModel()
        let mockViewDelegate = MockCryptoListViewDelegate()
        sut.viewDelegate = mockViewDelegate
        sut.testHooks.updateCryptoList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                              MockCryptoDataProvider.getCryproActiveNewCoin(),
                                              MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.testHooks.updateDisplayedList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                                 MockCryptoDataProvider.getCryproActiveNewCoin(),
                                                 MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.filterContentForSearchText("Name2")
        sut.filterResult(shouldShowFilteredResult: true,
                         filteredResults: [MockCryptoDataProvider.getCryproActiveNewCoin()])
        
        XCTAssertEqual(mockViewDelegate.errorType, .emptyFilterResult)
    }

    func testSelectMultipleFilterOptionsWithoutSearch() {
        let sut = CryptoListViewModel()
        let mockViewDelegate = MockCryptoListViewDelegate()
        sut.viewDelegate = mockViewDelegate
        mockViewDelegate.didReloadTableView.expectedFulfillmentCount = 2
        mockViewDelegate.didHideLoader.expectedFulfillmentCount = 2
        sut.testHooks.updateCryptoList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                              MockCryptoDataProvider.getCryproActiveNewCoin(),
                                              MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.testHooks.updateDisplayedList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                                 MockCryptoDataProvider.getCryproActiveNewCoin(),
                                                 MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.filterResult(shouldShowFilteredResult: true,
                         filteredResults: [MockCryptoDataProvider.getCryproActiveNewCoin(),
                                           MockCryptoDataProvider.getCryproInactiveCoin()])
        wait(for: [mockViewDelegate.didReloadTableView])
        wait(for: [mockViewDelegate.didHideLoader])
        wait(for: [mockViewDelegate.didHideError])
        XCTAssertEqual(sut.displayedCryptoList.count, 2)
    }
    
    func testEmptyFilterResult() {
        let sut = CryptoListViewModel()
        let mockViewDelegate = MockCryptoListViewDelegate()
        sut.viewDelegate = mockViewDelegate
        mockViewDelegate.didReloadTableView.expectedFulfillmentCount = 2
        mockViewDelegate.didHideLoader.expectedFulfillmentCount = 2
        sut.testHooks.updateCryptoList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                              MockCryptoDataProvider.getCryproActiveNewCoin(),
                                              MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.testHooks.updateDisplayedList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                                 MockCryptoDataProvider.getCryproActiveNewCoin(),
                                                 MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.filterResult(shouldShowFilteredResult: true,
                         filteredResults: [])
        wait(for: [mockViewDelegate.didReloadTableView])
        wait(for: [mockViewDelegate.didHideLoader])
        XCTAssertEqual(mockViewDelegate.errorType, .emptyFilterResult)
    }
    
    func testDeselectFilterOptionWithoutSearch() {
        let sut = CryptoListViewModel()
        let mockViewDelegate = MockCryptoListViewDelegate()
        sut.viewDelegate = mockViewDelegate
        mockViewDelegate.didReloadTableView.expectedFulfillmentCount = 2
        mockViewDelegate.didHideLoader.expectedFulfillmentCount = 2
        sut.testHooks.updateCryptoList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                              MockCryptoDataProvider.getCryproActiveNewCoin(),
                                              MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.testHooks.updateDisplayedList(with: [MockCryptoDataProvider.getCryproActivNewToken(),
                                                 MockCryptoDataProvider.getCryproActiveNewCoin(),
                                                 MockCryptoDataProvider.getCryproInactiveCoin()])
        sut.testHooks.updateFilterResult(activeFilters: [.activeCoins], filteredList: [MockCryptoDataProvider.getCryproActiveNewCoin()])
        sut.filterResult(shouldShowFilteredResult: false,
                         filteredResults: [])
        wait(for: [mockViewDelegate.didReloadTableView])
        wait(for: [mockViewDelegate.didHideLoader])
        wait(for: [mockViewDelegate.didHideError])
        XCTAssertEqual(sut.displayedCryptoList.count, 3)
    }
}
