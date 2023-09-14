//
//  WeatherDecodable.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 14/09/2023.
//

struct Weather:Decodable {
    let weather: [Weather]
    let temperature: Temperature

    enum CodingKeys: String, CodingKey {
        case weather
        case temperature = "main"
    }

    struct Weather:Decodable {
        let description: String
        let icon: String
    }

    struct Temperature:Decodable {
        let temp: Float
    }
}
