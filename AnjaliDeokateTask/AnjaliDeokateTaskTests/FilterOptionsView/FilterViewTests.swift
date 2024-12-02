//
//  FilterViewTests.swift
//  AnjaliDeokateTaskTests
//
//  Created by Anjali on 02/12/24.
//

import XCTest
@testable import AnjaliDeokateTask

final class FilterOptionsViewTests: XCTestCase {
    func testButton() {
        let mockViewModel = FilterOptionViewModel(activeFilters: [.activeCoins],
                                                  lastDisplayedList: [MockCryptoDataProvider.getCryproActivNewToken()])
        let sut = FilterOptionsView(viewModel: mockViewModel)
        
        XCTAssertEqual(sut.viewModel.testHooks.activeFilters, [.activeCoins])
        XCTAssertEqual(sut.viewModel.filterOptions, [.activeCoins,
                                                     .inactiveCoins,
                                                     .onlyTokens,
                                                     .onlyCoins,
                                                     .newCoins])
        
        XCTAssertEqual(sut.testHooks.butttons.count, 5)
        XCTAssertEqual(sut.testHooks.butttons[0].titleLabel?.text, "Active Coins")
        XCTAssertTrue(sut.testHooks.butttons[0].isSelected)
        XCTAssertEqual(sut.testHooks.butttons[0].imageView?.image?.imageAsset?.value(forKey: "assetName") as! String,
                       "checkmark.circle")
        XCTAssertEqual(sut.testHooks.butttons[1].titleLabel?.text, "Inactive Coins")
        XCTAssertFalse(sut.testHooks.butttons[1].isSelected)
        XCTAssertEqual(sut.testHooks.butttons[1].imageView?.image?.imageAsset?.value(forKey: "assetName") as! String,
                       "circle")
        XCTAssertEqual(sut.testHooks.butttons[2].titleLabel?.text, "Only Tokens")
        XCTAssertFalse(sut.testHooks.butttons[2].isSelected)
        XCTAssertEqual(sut.testHooks.butttons[2].imageView?.image?.imageAsset?.value(forKey: "assetName") as! String,
                       "circle")
        XCTAssertEqual(sut.testHooks.butttons[3].titleLabel?.text, "Only Coins")
        XCTAssertFalse(sut.testHooks.butttons[3].isSelected)
        XCTAssertEqual(sut.testHooks.butttons[3].imageView?.image?.imageAsset?.value(forKey: "assetName") as! String,
                       "circle")
        XCTAssertEqual(sut.testHooks.butttons[4].titleLabel?.text, "New Coins")
        XCTAssertFalse(sut.testHooks.butttons[4].isSelected)
        XCTAssertEqual(sut.testHooks.butttons[4].imageView?.image?.imageAsset?.value(forKey: "assetName") as! String,
                       "circle")
    }
    
    func testButtonAction() {
        let mockViewModel = FilterOptionViewModel(activeFilters: [.activeCoins],
                                                  lastDisplayedList: [MockCryptoDataProvider.getCryproActivNewToken()])
        let sut = FilterOptionsView(viewModel: mockViewModel)
        
        XCTAssertEqual(sut.viewModel.testHooks.activeFilters, [.activeCoins])
        XCTAssertEqual(sut.viewModel.filterOptions, [.activeCoins,
                                                     .inactiveCoins,
                                                     .onlyTokens,
                                                     .onlyCoins,
                                                     .newCoins])
        
        XCTAssertEqual(sut.testHooks.butttons.count, 5)
        XCTAssertEqual(sut.testHooks.butttons[0].titleLabel?.text, "Active Coins")
        XCTAssertTrue(sut.testHooks.butttons[0].isSelected)
        sut.testHooks.butttons[0].sendActions(for: .touchUpInside)
        XCTAssertEqual(sut.testHooks.butttons[0].titleLabel?.text, "Active Coins")
        XCTAssertFalse(sut.testHooks.butttons[0].isSelected)
    }
    
}
