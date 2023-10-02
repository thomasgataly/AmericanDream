//
//  WeatherService.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 14/09/2023.
//

import Foundation

final class WeatherService {

    var urlGenerator: WeatherUrlGenerator
    var session: URLSession

    init(urlGenerator: WeatherUrlGenerator, session: URLSession) {
        self.urlGenerator = urlGenerator
        self.session = session
    }

    func getWeather(cityName: String, _ callback: @escaping (Result<Weather, K.weather.error>) -> Void) {
        let task = session.dataTask(with: urlGenerator.generateUrl(cityName: cityName)) { data, response, error in
            guard let response = response as? HTTPURLResponse else { return }
            switch (response.statusCode) {
            case 200:
                do {
                    guard let data = data else { return }
                    let weather = try JSONDecoder().decode(Weather.self, from: data)
                    callback(.success(weather))
                } catch {
                    callback(.failure(K.weather.error.decodingError))
                }
            case 400:
                return callback(.failure(K.weather.error.badRequest))
            case 404:
                return callback(.failure(K.weather.error.notFoundCity))
            default:
                return callback(.failure(K.weather.error.commonError))
            }
        }
        task.resume()
    }
}
