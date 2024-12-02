//
//  CryptoListViewControllerTests.swift
//  AnjaliDeokateTaskTests
//
//  Created by Anjali on 02/12/24.
//

import Combine
import XCTest
@testable import AnjaliDeokateTask

extension XCTestCase {
    /// Creates an expectation for monitoring the given condition.
    /// - Parameters:
    ///   - condition: The condition to evaluate to be `true`.
    ///   - description: A string to display in the test log for this expectation, to help diagnose failures.
    /// - Returns: The expectation for matching the condition.
    func expectation(for condition: @autoclosure @escaping () -> Bool, description: String = "") -> XCTestExpectation {
        let predicate = NSPredicate { _, _ in
            return condition()
        }
                
        return XCTNSPredicateExpectation(predicate: predicate, object: nil)
    }
}

final class CryptoListViewControllerTests: XCTestCase {
    
    func testView() {
        let window = UIWindow()
        let mockService = MockCryptoService()
        let mockViewModel = CryptoListViewModel(service: mockService)
        let sut = CryptoListViewController(viewModel: mockViewModel)
        mockViewModel.viewDelegate =  sut
        let navigationController = UINavigationController(rootViewController: sut)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        XCTAssertNil(sut.testHooks.loaderView)
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.navigationItem.title, "COIN")
        XCTAssertEqual(sut.testHooks.searchController.searchBar.placeholder, "Search by Name or Symbol")
        XCTAssertEqual(sut.testHooks.filterOptionsView.isHidden, true)
        
        let filterOptionsViewShownExpectation = expectation(for: sut.testHooks.filterOptionsView.isHidden == false)
        wait(for: [filterOptionsViewShownExpectation])
        XCTAssertEqual(sut.testHooks.tableView.numberOfSections, 1)
        XCTAssertEqual(sut.testHooks.tableView.numberOfRows(inSection: 0), 2)
        
        sut.testHooks.searchController.searchBar.text = "Name1"
        let updateSearchExpectation = expectation(for: sut.testHooks.tableView.numberOfRows(inSection: 0) == 1)
        wait(for: [updateSearchExpectation])
        
        sut.testHooks.searchController.searchBar.text = "Random"
        let emptySearchExpectation = expectation(for: sut.testHooks.errorView != nil)
        let emptySearchErrorTypeExpectation = expectation(for: sut.testHooks.errorView?.testHooks.errorType == .emptySearchResult)
        wait(for: [emptySearchExpectation, emptySearchErrorTypeExpectation])
        
        sut.testHooks.searchController.searchBar.text = "Random2"
        let emptySearchExpectation2 = expectation(for: sut.testHooks.errorView != nil)
        let emptySearchErrorTypeExpectation2 = expectation(for: sut.testHooks.errorView?.testHooks.errorType == .emptySearchResult)

        wait(for: [emptySearchExpectation2, emptySearchErrorTypeExpectation2])
        
        sut.hideError()
        let hideErrorExpectation = expectation(for: sut.testHooks.errorView == nil)
        wait(for: [hideErrorExpectation])
        

        let emptyFilterExpectation = expectation(for: sut.testHooks.errorView != nil)
        let emptyFilterErrorTypeExpectation = expectation(for: sut.testHooks.errorView?.testHooks.errorType == .emptyFilterResult)
        sut.testHooks.filterOptionsView.testHooks.butttons[1].sendActions(for: .touchUpInside)
        wait(for: [emptyFilterExpectation, emptyFilterErrorTypeExpectation])

    }
}


class MockCryptoService: CryptoService {
    
    func getCryptoList() -> AnyPublisher<[Crypto], any Error> {
        return Just([MockCryptoDataProvider.getCryproActiveNewCoin(), MockCryptoDataProvider.getCryproActivNewToken()])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    
}
