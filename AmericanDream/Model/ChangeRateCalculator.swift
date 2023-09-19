//
//  ChangeRateCalculator.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 05/09/2023.

import Foundation

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

    func calculate(amount:Double, callback: @escaping (Result<Double, K.changeRateApi.error>) -> Void) -> Void {
        let existingRates = cache.load(key: DateHelper.getTodayDateText())
        if let existingUsdRate = existingRates[K.changeRateApi.targetCurrency] {
            callback(.success(amount * existingUsdRate))
            return
        }

        getNewRates(amount, callback)
    }

    private func getNewRates(_ amount: Double, _ callback: @escaping (Result<Double, K.changeRateApi.error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let apiKey {
            request.url?.append(queryItems: [URLQueryItem(name: K.changeRateApi.apiKeyParameterName, value: apiKey)])
        }
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(.failure(K.changeRateApi.error.commonError))
                    return
                }

                do {
                    let changeRate = try JSONDecoder().decode(ChangeRate.self, from: data)
                    self.cache.save(key: changeRate.dateText, value: changeRate.rates)
                    if let usdRate = changeRate.rates[K.changeRateApi.targetCurrency] {
                        callback(.success(amount * usdRate))
                    } else {
                        callback(.failure(K.changeRateApi.error.missingCurrency))
                    }
                } catch {
                    callback(.failure(K.changeRateApi.error.decodingError))
                }
            }
        }
        task.resume()
    }
}
