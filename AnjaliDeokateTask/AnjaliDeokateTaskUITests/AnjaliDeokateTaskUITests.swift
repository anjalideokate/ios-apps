//
//  AnjaliDeokateTaskUITests.swift
//  AnjaliDeokateTaskUITests
//
//  Created by Anjali on 02/12/24.
//

import XCTest

final class AnjaliDeokateTaskUITests: XCTestCase {
    let app = XCUIApplication()
    
    func testViews() throws {
        app.launchArguments.append("UITesting")
        app.launch()
        validateNavigationBar()
        validateSearchBar()
        validateTable()
    }
}

//MARK: Utilities to validate subviews
extension AnjaliDeokateTaskUITests {
    
    func validateNavigationBar() {
        XCTAssertTrue(app.navigationBars["COIN"].exists)
    }
    
    func validateSearchBar() {
        XCTAssertTrue(app.searchFields["Search by Name or Symbol"].exists)
    }
    
    func validateTable() {
        let tableView = app.tables["TableView"]
        XCTAssertTrue(tableView.exists)
        if tableView.cells.count == 0 {
            validateApiError()
        } else {
            XCTAssertEqual(app.tables["TableView"].cells.count, 26)
            validateFilterOptionsView()
        }
    }
    
    func validateFilterOptionsView() {
        let filterOptionsView = app.otherElements["FilterOptionsView"]
        XCTAssertTrue(filterOptionsView.exists)
        XCTAssertEqual(filterOptionsView.buttons.count, 5)
        XCTAssertEqual(filterOptionsView.buttons.element(boundBy: 0).label,
                       "Active Coins")
        XCTAssertEqual(filterOptionsView.buttons.element(boundBy: 1).label,
                       "Inactive Coins")
        XCTAssertEqual(filterOptionsView.buttons.element(boundBy: 2).label,
                       "Only Tokens")
        XCTAssertEqual(filterOptionsView.buttons.element(boundBy: 3).label,
                       "Only Coins")
        XCTAssertEqual(filterOptionsView.buttons.element(boundBy: 4).label,
                       "New Coins")
    }
    
    func validateApiError() {
        XCTAssertTrue(app.images["ApiError"].exists)
        XCTAssertTrue(app.staticTexts["Whoops"].exists)
        XCTAssertTrue(app.staticTexts["Something went wrong. Please retry again later."].exists)
    }
}
