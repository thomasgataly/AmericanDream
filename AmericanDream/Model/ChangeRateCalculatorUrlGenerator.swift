//
//  ChangeRateCalculatorUrlGenerator.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 20/09/2023.
//

import Foundation

class ChangeRateCalculatorUrlGenerator {
    func generateUrl() -> URLRequest {
        let url = URL(string: K.changeRateApi.endpoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.url?.append(queryItems: [URLQueryItem(name: K.changeRateApi.apiKeyParameterName, value: K.changeRateApi.apiKey)])

        return request
    }
}
