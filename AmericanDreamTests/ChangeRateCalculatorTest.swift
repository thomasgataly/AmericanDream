//
//  ChangeRateCalculator.swift
//  AmericanDreamTests
//
//  Created by Thomas Gataly on 14/09/2023.
//

import XCTest
@testable import AmericanDream

final class ChangeRateCalculatorTest: XCTestCase {

    func testOK() {
        //Given
        let changeRateCalculator = ChangeRateCalculator(url: URL(string: "https://google.fr")!, session: URLSessionFake(data: nil, response: nil, error: nil))
        //When
        changeRateCalculator.calculate(amount: 10.0) { result, error in
            //Then
            XCTAssertNil(result)
        }
    }

}
