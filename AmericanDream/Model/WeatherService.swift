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
    let error:Error? = nil

    static func getWeather(cityName: String, _ callback: @escaping (Weather?, Error?) -> Void) {
        var request = URLRequest(url: self.url)
        request.httpMethod = "GET"
        request.url?.append(queryItems: [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "lang", value: "fr"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: self.key)
        ])
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let weather = try JSONDecoder().decode(Weather.self, from: data)
                    DispatchQueue.main.async {
                        callback(weather, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        callback(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
}
