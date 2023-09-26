//
//  WeatherServiceUrlGenerator.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 26/09/2023.
//

import Foundation

class WeatherUrlGenerator {
    func generateUrl(cityName:String) -> URLRequest {
        var request = URLRequest(url: URL(string: K.weather.api.endpoint)!)
        request.httpMethod = "GET"
        request.url?.append(queryItems: [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "lang", value: "fr"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: K.weather.api.apiKey)
        ])

        return request
    }
}
