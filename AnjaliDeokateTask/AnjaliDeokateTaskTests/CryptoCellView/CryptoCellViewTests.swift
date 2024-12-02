//
//  CryptoCellViewTests.swift
//  AnjaliDeokateTaskTests
//
//  Created by Anjali on 01/12/24.
//

import XCTest
@testable import AnjaliDeokateTask

final class CryptoCellViewTests: XCTestCase {

    func testActiveNewCoin() {
        let sut = CryptoCellView()
        let mockViewModel = CryptoCellViewModel(crypto: MockCryptoDataProvider.getCryproActiveNewCoin())
        sut.configure(viewModel: mockViewModel)
        XCTAssertEqual(sut.testHooks.titleLabel.text, "Name1")
        XCTAssertEqual(sut.testHooks.subtitleLabel.text, "Symbol1")
        XCTAssertEqual(sut.testHooks.imageIcon.image, .activeCoin)
        XCTAssertEqual(sut.testHooks.newTagIcon.image, .newTag)
        XCTAssertEqual(sut.testHooks.containerView.subviews.count, 4)
    }
}
