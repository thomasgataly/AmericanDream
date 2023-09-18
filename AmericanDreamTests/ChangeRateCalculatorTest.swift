//
//  ChangeRateCalculator.swift
//  AmericanDreamTests
//
//  Created by Thomas Gataly on 14/09/2023.
//

import XCTest
@testable import AmericanDream

final class ChangeRateCalculatorTest: XCTestCase {

    func testWrongDataReturnsDecodingError() {
        //Given
        let url = URL(string: "https://wrong-data.com")!
        URLProtocolStub.testURLs = [url: Data("Invalid data".utf8)]
        let changeRateCalculator = ChangeRateCalculator(session: getSession())
        let expectation = XCTestExpectation(description: "wait...")

        //When
        changeRateCalculator.calculate(amount: 10.0) { result in
            //Then
            if case .failure(let failure) = result {
                XCTAssertEqual(failure, ChangeRateCalculatorError.decodingError)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testInvalidDataReturnsMissingCurrencyError() {
        //Given
        let url = URL(string: "https://incomplete-data.com")!
        guard let jsonData = readLocalJSONFile(forName: "invalid-rates") else { return XCTFail("file not found") }
        URLProtocolStub.testURLs = [url: jsonData]
        let changeRateCalculator = ChangeRateCalculator(session: getSession())
        let expectation = XCTestExpectation(description: "wait...")

        //When
        changeRateCalculator.calculate(amount: 10.0) { result in
            //Then
            if case .failure(let failure) = result {
                XCTAssertEqual(failure, ChangeRateCalculatorError.missingCurrency)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }

    //todo
    func testCorrectDataReturnsConvertedAmout() {

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
