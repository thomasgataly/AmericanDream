//
//  ChangeRateCalculatorUrlGeneratorFake.swift
//  AmericanDreamTests
//
//  Created by Thomas Gataly on 20/09/2023.
//

import Foundation
@testable import AmericanDream

class ChangeRateCalculatorUrlGeneratorFake:ChangeRateCalculatorUrlGenerator {

    var url:URL
    init(url:URL) {
        self.url = url
    }

    override func generateUrl() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        return request
    }
}
