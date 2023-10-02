//
//  TranslatorTest.swift
//  AmericanDreamTests
//
//  Created by Thomas Gataly on 26/09/2023.
//


import XCTest
@testable import AmericanDream

final class TranslationServiceTest:XCTestCase {

    let url = URL(string: "https://url.com")!
    private var sut:TranslationService!

    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        sut = TranslationService(urlGenerator: TranslationServiceUrlGeneratorFake(url: url), session: URLSession(configuration: config))
        URLProtocolStub.testURLs = [:]
        URLProtocolStub.testErrorURLs = [:]
    }

    func testWrongDataReturnsDecodingError() {
        //Given
        URLProtocolStub.testURLs = [url: Data("Wrong data".utf8)]
        let expectation = XCTestExpectation(description: "wait...")

        //When
        sut.translate(text: "bonjour", source: "fr", target: "en") { result in
            //Then
            guard case .failure(let failure) = result else { return XCTFail() }
            XCTAssertEqual(failure, K.translator.error.decodingError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testNetworkErrorReturnsGenericError() {
        //Given
        URLProtocolStub.testErrorURLs = [url: URLError(URLError.Code(rawValue: 500))]
        let expectation = XCTestExpectation(description: "wait...")

        //When
        sut.translate(text: "bonjour", source: "fr", target: "en") { result in
            //Then
            guard case .failure(let failure) = result else { return XCTFail() }
            XCTAssertEqual(failure, K.translator.error.commonError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testCorrectDataReturnsTranslatedText() {
        //Given
        guard let jsonData = readLocalJSONFile(forName: "valid-translation", fromClass: TranslationServiceTest.self) else { return XCTFail("file not found") }
        URLProtocolStub.testURLs = [url: jsonData]
        let expectation = XCTestExpectation(description: "wait...")

        //When
        sut.translate(text: "bonjour", source: "fr", target: "en") { result in
            //Then get result
            guard case .success(let result) = result else { return XCTFail() }
            XCTAssertEqual(result, "hello")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
}
