//
//  WeatherService.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 14/09/2023.
//

import Foundation

final class WeatherService {

    var url:URL
    var session:URLSession
    var apiKey:String?

    init(url: URL, session: URLSession, apiKey: String?) {
        self.url = url
        self.session = session
        self.apiKey = apiKey
    }

    func getWeather(cityName: String, _ callback: @escaping (Result<Weather, K.weatherApi.error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let apiKey = apiKey {
            request.url?.append(queryItems: [
                URLQueryItem(name: "q", value: cityName),
                URLQueryItem(name: "lang", value: "fr"),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "appid", value: apiKey)
            ])
        }
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                callback(.failure(K.weatherApi.error.commonError))
                return
            }

            if let response = response as? HTTPURLResponse {
                if response.statusCode == 400 {
                    callback(.failure(K.weatherApi.error.missingCity))
                    return
                }
                if response.statusCode == 404 {
                    callback(.failure(K.weatherApi.error.notFoundCity))
                    return
                }
            }

            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                callback(.success(weather))
            } catch {
                callback(.failure(K.weatherApi.error.decodingError))
            }
        }
        task.resume()
    }
}
