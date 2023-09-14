//
//  WeatherService.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 14/09/2023.
//

import Foundation

final class WeatherService {
    static let url = URL(string: "https://api.openweathermap.org/data/2.5/weather")!
    private static let key = "71819d34f088ab38323f1d41880f292a"

    static func getWeather(cityName: String, _ callback: @escaping (String, String, Float) -> Void) {
        var request = URLRequest(url: self.url)
        request.httpMethod = "GET"
        request.url?.append(queryItems: [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "lang", value: "fr"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: self.key)
        ])
//        let body = "q=\(cityName)&lang=fr&units=metric&appid=\(self.key)"
//        request.httpBody = body.data(using: .utf8)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let weatherDecoded = try JSONDecoder().decode(WeatherDecodable.self, from: data)
                    DispatchQueue.main.async {
                        callback(weatherDecoded.weather[0].description, weatherDecoded.weather[0].icon, weatherDecoded.temperature.temp)
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
}
