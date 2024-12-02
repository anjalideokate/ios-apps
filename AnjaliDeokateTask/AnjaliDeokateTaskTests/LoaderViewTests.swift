//
//  LoaderViewTests.swift
//  AnjaliDeokateTaskTests
//
//  Created by Anjali on 01/12/24.
//

import XCTest
@testable import AnjaliDeokateTask

final class LoaderViewTests: XCTestCase {
    
    func testSpinner() {
        let sut = LoaderView()
        XCTAssertTrue(sut.testHooks.spinner.isAnimating)
        XCTAssertEqual(sut.testHooks.spinner.color, .yellow)
    }
}
