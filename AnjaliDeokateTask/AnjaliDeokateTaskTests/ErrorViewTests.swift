//
//  ErrorViewTests.swift
//  AnjaliDeokateTaskTests
//
//  Created by Anjali on 01/12/24.
//

import XCTest
@testable import AnjaliDeokateTask

final class ErrorViewTests: XCTestCase {
    
    func testApiErrorView() {
        let sut = ErrorView(errorType: .apiError)
        XCTAssertEqual(sut.testHooks.errorType, .apiError)
        XCTAssertEqual(sut.testHooks.imageView.image, .apiError)
        XCTAssertEqual(sut.testHooks.titleLabel.text, "Whoops")
        XCTAssertEqual(sut.testHooks.subtitleLabel.text, "Something went wrong. Please retry again later.")
    }

    func testSearchResultErrorView() {
        let sut = ErrorView(errorType: .emptySearchResult)
        XCTAssertEqual(sut.testHooks.errorType, .emptySearchResult)
        XCTAssertEqual(sut.testHooks.imageView.image, .emptySearchResult)
        XCTAssertEqual(sut.testHooks.titleLabel.text, "No results found")
        XCTAssertEqual(sut.testHooks.subtitleLabel.text, "Try searching another keyword.")
    }
    
    func testFilterResultErrorView() {
        let sut = ErrorView(errorType: .emptyFilterResult)
        XCTAssertEqual(sut.testHooks.errorType, .emptyFilterResult)
        XCTAssertEqual(sut.testHooks.imageView.image, .emptyFilterResult)
        XCTAssertEqual(sut.testHooks.titleLabel.text, "No match for filter")
        XCTAssertEqual(sut.testHooks.subtitleLabel.text, "Try another filter option or new search keyword")
    }
}
