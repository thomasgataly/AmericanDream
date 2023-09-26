//
//  ChangeRateCalculatorUrlGenerator.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 20/09/2023.
//

import Foundation

class ChangeRateUrlGenerator {
    func generateUrl() -> URLRequest {
        let url = URL(string: K.changeRate.api.endpoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.url?.append(queryItems: [URLQueryItem(name: K.changeRate.api.apiKeyParameterName, value: K.changeRate.api.apiKey)])

        return request
    }
}
