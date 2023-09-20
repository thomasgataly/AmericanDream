//
//  ChangeRateCalculator.swift
//  AmericanDreamTests
//
//  Created by Thomas Gataly on 14/09/2023.

import XCTest
@testable import AmericanDream

final class ChangeRateCalculatorTest: XCTestCase {

    private var url = URL(string: "https://url.com")!
    private var sut:ChangeRateCalculator!

    override func setUp() {
        sut = ChangeRateCalculator(
            urlGenerator:ChangeRateCalculatorUrlGeneratorFake(url: url),
            session: getSession(),
            cache: InMemoryChangeRateCacheManager()
        )
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
            XCTAssertEqual(failure, K.changeRateApi.error.decodingError)
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
            XCTAssertEqual(failure, K.changeRateApi.error.missingCurrency)
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
            XCTAssertEqual(failure, K.changeRateApi.error.commonError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testCorrectDataReturnsConvertedAmountAndSaveInCache() {
        //Given
        guard let jsonData = readLocalJSONFile(forName: "valid-rates") else { return XCTFail("file not found") }
        URLProtocolStub.testURLs = [url: jsonData]
        let amount = 10.0
        let rateFileUSDRate = 1.066906
        let rateFileAEDRate = 3.918782
        let rateFileZWLRate = 343.543219
        let expectedResult = amount * rateFileUSDRate
        let rateFileDateText = "2023-09-14"
        let expectation = XCTestExpectation(description: "wait...")

        //When
        sut.calculate(amount: amount) { result in
            //Then get result
            guard case .success(let result) = result else { return XCTFail() }
            XCTAssertEqual(result, expectedResult)
            expectation.fulfill()

            //and save in cache
            guard let savedRates = InMemoryChangeRateCacheManager.rates[rateFileDateText] else { return XCTFail("rates not saved") }
            XCTAssertEqual(savedRates["AED"], rateFileAEDRate)
            XCTAssertEqual(savedRates["USD"], rateFileUSDRate)
            XCTAssertEqual(savedRates["ZWL"], rateFileZWLRate)
            XCTAssertEqual(InMemoryChangeRateCacheManager.rates[rateFileDateText]?.count, 3)
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testCorrectDataReturnsConvertedAmountFromCache() {
        //Given
        guard let jsonData = readLocalJSONFile(forName: "valid-rates") else { return XCTFail("file not found") }
        URLProtocolStub.testURLs = [url: jsonData]
        let amount = 10.0
        let rateFileUSDRate = 1.066906
        let expectedResult = amount * rateFileUSDRate
        let expectation = XCTestExpectation(description: "wait...")

        //Set a rate already present in the cache
        InMemoryChangeRateCacheManager.rates[DateHelper.getTodayDateText()] = ["USD":rateFileUSDRate]

        //When
        sut.calculate(amount: amount) { result in
            //Then get result
            guard case .success(let result) = result else { return XCTFail() }
            XCTAssertEqual(result, expectedResult)
            expectation.fulfill()

            //cache is still the same
            XCTAssertEqual(InMemoryChangeRateCacheManager.rates[DateHelper.getTodayDateText()]?.count, 1)
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
