//
//  CurrencyServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Richard Arif Mazid on 07/09/2022.
//


import XCTest
@testable import LeBaluchon

class CurrencyServiceTestCase: XCTestCase {

    var currency: CurrencyService!
    private let amountToConvert = "10"

    override func setUp() {
        super.setUp()
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.currencyCorrectData
            return (response, data, error)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        currency = CurrencyService(session: session)
    }

    // MARK: - Network call tests
    func testGetRatesShouldPostFailedCallbackIfError() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = FakeResponseData.currencyError
            let data: Data? = nil
            return (response, data, error)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let conversionService = CurrencyService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        conversionService.getExchange(base: "EUR", q: amountToConvert, target: "USD") { (success, searchRate) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(searchRate)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGetRatesShouldPostFailedCallbackIfNoData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = nil
            let data: Data? = nil
            return (response, data, error)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let conversionService = CurrencyService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        conversionService.getExchange(base: "EUR", q: amountToConvert, target: "USD") { (success, searchRate) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(searchRate)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testGetRatesShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = nil
            let data: Data? = FakeResponseData.currencyCorrectData
            return (response, data, error)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let conversionService = CurrencyService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        conversionService.getExchange(base: "EUR", q: amountToConvert, target: "USD") { (success, searchRate) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(searchRate)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetRatesShouldPostFailedCallbackIfIncorrectData() {
        /// Given
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.currencyIncorrectData
            return (response, data, error)
        }
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let conversionService = CurrencyService(session: session)
        // When
        conversionService.getExchange(base: "EUR", q: amountToConvert, target: "USD") { (success, searchRate) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(searchRate)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetRatesShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.currencyCorrectData
            return (response, data, error)
        }
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let conversionService = CurrencyService(session: session)
        // When
        conversionService.getExchange(base: "EUR", q: amountToConvert, target: "USD") { (success, searchRate) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(searchRate)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGivenChangeSourceCurrency_WhenTapOnSwapButton_CurrencyChanged() {
        CurrencyService.shared.changeCurrency(source: "USD", target: "EUR")

        XCTAssertTrue(CurrencyService.shared.changeSource == "USD")
        XCTAssertTrue(CurrencyService.shared.changeTarget == "EUR")
    }
}

