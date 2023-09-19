//
//  ChangeRateCalculator.swift
//  AmericanDreamTests
//
//  Created by Thomas Gataly on 14/09/2023.

import XCTest
@testable import AmericanDream

final class ChangeRateCalculatorTest: XCTestCase {

    let url = URL(string: "https://url.com")!
    private var sut:ChangeRateCalculator!

    override func setUp() {
        sut = ChangeRateCalculator(url:url,session: getSession(), apiKey: nil,cache: InMemoryChangeRateCacheManager())
        URLProtocolStub.testURLs = [:]
        URLProtocolStub.testErrorURLs = [:]
        InMemoryChangeRateCacheManager.rates = [:]
    }

    func testWrongDataReturnsDecodingError() {
        //Given
        URLProtocolStub.testURLs = [url: Data("Wrong data".utf8)]
        let expectation = XCTestExpectation(description: "wait...")

        //When
        sut.calculate(amount: 10.0) { result in
            //Then
            guard case .failure(let failure) = result else { return XCTFail() }
            XCTAssertEqual(failure, ChangeRateCalculatorError.decodingError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testInvalidDataReturnsMissingCurrencyError() {
        //Given
        guard let invalidJsonData = readLocalJSONFile(forName: "invalid-rates") else { return XCTFail("file not found") }
        URLProtocolStub.testURLs = [url: invalidJsonData]
        let expectation = XCTestExpectation(description: "wait...")

        //When
        sut.calculate(amount: 10.0) { result in
            //Then
            guard case .failure(let failure) = result else { return XCTFail() }
            XCTAssertEqual(failure, ChangeRateCalculatorError.missingCurrency)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testNetworkErrorReturnsGenericError() {
        //Given
        URLProtocolStub.testErrorURLs = [url: URLError(URLError.Code(rawValue: 500))]
        let expectation = XCTestExpectation(description: "wait...")

        //When
        sut.calculate(amount: 10.0) { result in
            //Then
            guard case .failure(let failure) = result else { return XCTFail() }
            XCTAssertEqual(failure, ChangeRateCalculatorError.commonError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testCorrectDataReturnsConvertedAmount() {
        guard let jsonData = readLocalJSONFile(forName: "valid-rates") else { return XCTFail("file not found") }
        URLProtocolStub.testURLs = [url: jsonData]
        let expectation = XCTestExpectation(description: "wait...")
        let amount = Float(10.0)
        let expectedResult = amount * 1.066906

        //When
        sut.calculate(amount: amount) { result in
            //Then
            guard case .success(let result) = result else { return XCTFail() }
            XCTAssertEqual(result, expectedResult)
            expectation.fulfill()

            //todo crash here
            guard let savedRates = InMemoryChangeRateCacheManager.rates[DateHelper.getTodayDateText()] else { return XCTFail("rates not saved") }
            XCTAssertEqual(savedRates["AED"], 3.918782)
            XCTAssertEqual(savedRates["USD"], 1.066906)
            XCTAssertEqual(savedRates["ZWL"], 343.543219)
            XCTAssertEqual(InMemoryChangeRateCacheManager.rates[DateHelper.getTodayDateText()]?.count, 3)
        }
        wait(for: [expectation], timeout: 0.1)
    }

    private func getSession() -> (URLSession) {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]

        return URLSession(configuration: config)
    }

    private func readLocalJSONFile(forName name: String) -> Data? {
        let bundle = Bundle(for: ChangeRateCalculatorTest.self)
        let url = bundle.url(forResource: name, withExtension: "json")!
        return try! Data(contentsOf: url)
    }
}
