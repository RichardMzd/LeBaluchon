//
//  WeatherServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Richard Arif Mazid on 07/09/2022.
//

import XCTest
@testable import LeBaluchon


class WeatherServiceCase: XCTestCase {

    var weather: WeatherService!
    private let city = "New-york"

    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        weather = WeatherService(session: session)
    }
    
    // MARK: - Network call tests
    func testGetWeatherShouldPostFailedCallbackIfError() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = FakeResponseData.weatherError
            let data: Data? = nil
            return (response, data, error)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let weatherService = WeatherService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(city: "New York") { (success, weatherResult) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weatherResult)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGetWeatherShouldPostFailedCallbackIfNoData() {
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
        let weatherService = WeatherService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(city: city) { (success, weatherResult) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weatherResult)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGetWeatherShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = nil
            let data: Data? = FakeResponseData.weatherCorrectData
            return (response, data, error)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let weatherService = WeatherService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(city: "New York") { (success, weatherResult) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weatherResult)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfIncorrectData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.weatherIncorrectData
            return (response, data, error)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let weatherService = WeatherService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(city: city) { (success, weatherResult) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weatherResult)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherInEnglishShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.weatherCorrectData
            return (response, data, error)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let weatherService = WeatherService(session: session)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(city: city) { (success, weatherResult) in
            let temp = 290.13
            let country = "FR"
            let city = "Dugny"
            let condition = "broken clouds"
            let sunrise = 1662614205
            let sunset = 1662661190
            let icon = "04d"
            let date = "Jeu. 1 janvier 01:00"
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(weatherResult)
            XCTAssertEqual(temp, weatherResult?.main?.temp)
            XCTAssertEqual(country, weatherResult?.sys?.country)
            XCTAssertEqual(city, weatherResult?.name)
            XCTAssertEqual(condition, weatherResult?.weather?.first?.description)
            XCTAssertEqual(sunset, weatherResult?.sys?.sunset)
            XCTAssertEqual(sunrise, weatherResult?.sys?.sunrise)
            XCTAssertEqual(icon, weatherResult?.weather?.first?.icon)
            XCTAssertEqual(icon, weatherResult?.updateIcon(image: icon))
            XCTAssertEqual(date, weatherResult?.timeSet(time: Int(date) ?? 13))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
