//
//  TranslationServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Richard Arif Mazid on 03/09/2022.
//

import XCTest
@testable import LeBaluchon

class TranslationServiceTestCase: XCTestCase {
    
    var translation: TranslationService!
        private let textToTranslate = "bonjour"

        override func setUp() {
            super.setUp()
            TestURLProtocol.loadingHandler = { request in
                let response: HTTPURLResponse = FakeResponseData.responseOK
                let error: Error? = nil
                let data: Data? = FakeResponseData.translateCorrectData
                return (response, data, error)
            }
            let configuration = URLSessionConfiguration.ephemeral
            configuration.protocolClasses = [TestURLProtocol.self]
            let session = URLSession(configuration: configuration)
            translation = TranslationService(session: session)
        }
    
    func testGetQuoteShouldPostFailedCallbackIfError() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = FakeResponseData.translateError
            let data: Data? = nil
            return (response, data, error)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let translationService = TranslationService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        translationService.translate(source: "fr", q: textToTranslate, target: "en") { (success, translatedResponse) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translatedResponse)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuoteShouldPostFailedCallbackIfNoData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = nil
            return (response, data, error)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let translationService = TranslationService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        translationService.translate(source: "fr", q: textToTranslate, target: "en") { (success, translatedResponse) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translatedResponse)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGetQuoteShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = nil
            let data: Data? = FakeResponseData.translateCorrectData
            return (response, data, error)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let translationService = TranslationService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        translationService.translate(source: "fr", q: textToTranslate, target: "en") { success, translatedResponse in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translatedResponse)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetQuoteShouldPostFailedCallbackIfIncorrectData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.translateIncorrectData
            return (response, data, error)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let translationService = TranslationService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        translationService.translate(source: "fr", q: textToTranslate, target: "en") { success, translatedResponse in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translatedResponse)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGetQuoteShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.translateCorrectData
            return (response, data, error)
        }
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let translationService = TranslationService(session: session)
        // When
        translationService.translate(source: "fr", q: textToTranslate, target: "en") { (success, translatedResponse) in
            let text = "Hello"
            
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(translatedResponse)
            XCTAssertEqual(text, translatedResponse!.data.translations[0].translatedText)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGivenChangeSourceLanguage_WhenTapOnChangeLanguageButton_LanguageChanged() {
        TranslationService.shared.changeLanguage(source: "en", target: "fr")

        XCTAssertTrue(TranslationService.langSource == "en")
        XCTAssertTrue(TranslationService.langTarget == "fr")
    }
}
