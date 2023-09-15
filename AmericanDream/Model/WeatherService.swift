//
//  WeatherService.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 14/09/2023.
//

import Foundation

enum WeatherServiceError:String,Error {
    case missingCity = "Veuillez saisir une ville"
    case notFoundCity = "Ville introuvable"
    case commonError = "Une erreur est survenue"
    case decodingError = "Données incorrectes"
}

final class WeatherService:NetworkManager {

    func getWeather(cityName: String, _ callback: @escaping (Result<Weather, WeatherServiceError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.url?.append(queryItems: [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "lang", value: "fr"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: Constants.weatherApi.apiKey)
        ])
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                callback(.failure(WeatherServiceError.commonError))
                return
            }

            if let response = response as? HTTPURLResponse {
                if response.statusCode == 400 {
                    callback(.failure(WeatherServiceError.missingCity))
                    return
                }
                if response.statusCode == 404 {
                    callback(.failure(WeatherServiceError.notFoundCity))
                    return
                }
            }

            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                callback(.success(weather))
            } catch {
                callback(.failure(WeatherServiceError.decodingError))
            }
        }
        task.resume()
    }
}
