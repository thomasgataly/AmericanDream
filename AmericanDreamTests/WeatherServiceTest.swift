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
        sut = WeatherService(url:url,session: getSession(), apiKey: nil)
        URLProtocolStub.testURLs = [:]
        URLProtocolStub.testErrorURLs = [:]
    }

    func testNetworkErrorReturnsGenericError() {
        //Given
        URLProtocolStub.testErrorURLs = [url: URLError(URLError.Code(rawValue: 500))]
        let expectation = XCTestExpectation(description: "wait...")

        //When
        sut.getWeather(cityName: "Paris") { result in
            //Then
            guard case .failure(let failure) = result else { return XCTFail() }
            XCTAssertEqual(failure, K.weatherApi.error.commonError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }

    private func getSession() -> (URLSession) {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        return URLSession(configuration: config)
    }

}
