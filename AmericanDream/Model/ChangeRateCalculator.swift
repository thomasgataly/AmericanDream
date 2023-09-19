//
//  ChangeRateCalculator.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 05/09/2023.

import Foundation

enum ChangeRateCalculatorError:String,Error {
    case missingCurrency = "Taux introuvable"
    case commonError = "Une erreur est survenue"
    case decodingError = "Données incorrectes"
}

final class ChangeRateCalculator {

    var url:URL
    var session:URLSession
    var apiKey:String?
    var cache:ChangeRateCacheManager

    init(url: URL, session: URLSession, apiKey: String?, cache: ChangeRateCacheManager) {
        self.url = url
        self.session = session
        self.apiKey = apiKey
        self.cache = cache
    }

    func calculate(amount:Float, callback: @escaping (Result<Float, ChangeRateCalculatorError>) -> Void) -> Void {
        let existingRates = getExistingRates()
        if let existingUsdRate = existingRates["USD"] {
            callback(.success(amount * existingUsdRate))
            return
        }

        getNewRates(amount, callback)
    }

    private func getExistingRates() -> [String:Float] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDateText = dateFormatter.string(from: Date())

        return cache.load(key: todayDateText)
    }

    private func getNewRates(_ amount: Float, _ callback: @escaping (Result<Float, ChangeRateCalculatorError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let apiKey {
            request.url?.append(queryItems: [URLQueryItem(name: "access_key", value: apiKey)])
        }
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                callback(.failure(ChangeRateCalculatorError.commonError))
                return
            }

            do {
                let changeRate = try JSONDecoder().decode(ChangeRate.self, from: data)
                self.cache.save(key: changeRate.dateText, value: changeRate.rates)
                if let usdRate = changeRate.rates["USD"] {
                    callback(.success(amount * usdRate))
                } else {
                    callback(.failure(ChangeRateCalculatorError.missingCurrency))
                }
            } catch {
                callback(.failure(ChangeRateCalculatorError.decodingError))
            }
        }
        task.resume()
    }
}
