//
//  WeatherServiceTest.swift
//  AmericanDreamTests
//
//  Created by Thomas Gataly on 20/09/2023.
//

import XCTest
@testable import AmericanDream

final class WeatherServiceTest:XCTestCase {
    let url = URL(string: "https://url.com")!
    private var sut:WeatherService!

    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        sut = WeatherService(urlGenerator: WeatherServiceUrlGeneratorFake(url: url) ,session: URLSession(configuration: config))
        URLProtocolStub.data = [:]
        URLProtocolStub.error = [:]
    }

    func testNetworkErrorReturnsGenericError() {
        //Given
        URLProtocolStub.response = [url: HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: [:])!]
        let expectation = XCTestExpectation(description: "wait...")

        //When
        sut.getWeather(cityName: "Paris") { result in
            //Then
            guard case .failure(let failure) = result else { return XCTFail() }
            XCTAssertEqual(failure, K.weather.error.commonError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testMissingCityReturnsMissingCityError() {
        //Given
        URLProtocolStub.response = [url: HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: [:])!]
        let expectation = XCTestExpectation(description: "wait...")

        //When
        sut.getWeather(cityName: "notFoundableCity") { result in
            //Then
            guard case .failure(let failure) = result else { return XCTFail() }
            XCTAssertEqual(failure, K.weather.error.notFoundCity)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testNotFoundCityReturnsNotFoundError() {
        //Given
        URLProtocolStub.response = [url: HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: [:])!]
        let expectation = XCTestExpectation(description: "wait...")

        //When
        sut.getWeather(cityName: "") { result in
            //Then
            guard case .failure(let failure) = result else { return XCTFail() }
            XCTAssertEqual(failure, K.weather.error.badRequest)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)

    }

    func testInvalidDataReturnsDecodingError() {
        //Given
        URLProtocolStub.data = [url: Data("Wrong data".utf8)]
        let expectation = XCTestExpectation(description: "wait...")

        //When
        sut.getWeather(cityName: "Paris") { result in
            //Then
            guard case .failure(let failure) = result else { return XCTFail() }
            XCTAssertEqual(failure, K.weather.error.decodingError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testOkReturnsWeather() {
        guard let jsonData = readLocalJSONFile(forName: "weather-200", fromClass: WeatherServiceTest.self) else { return XCTFail("file not found") }
        URLProtocolStub.data = [url: jsonData]
        let expectation = XCTestExpectation(description: "wait...")

        //When
        sut.getWeather(cityName: "Pontault-Combault") { result in
            //Then get result
            guard case .success(let result) = result else { return XCTFail() }
            XCTAssertEqual(result.temperature.temp, 290.25)
            XCTAssertNotNil(result.weather[0].description)
            XCTAssertNotNil(result.weather[0].icon)
            expectation.fulfill()

        }
        wait(for: [expectation], timeout: 0.1)
    }

}
