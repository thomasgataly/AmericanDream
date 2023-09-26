//
//  WeatherServiceUrlGeneratorFake.swift
//  AmericanDreamTests
//
//  Created by Thomas Gataly on 27/09/2023.
//

import Foundation
@testable import AmericanDream

class WeatherServiceUrlGeneratorFake:WeatherUrlGenerator {
    var url: URL
    init(url: URL) {
        self.url = url
    }

    override func generateUrl(cityName: String) -> URLRequest {
        return URLRequest(url: url)
    }
}
