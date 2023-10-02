//
//  ChangeRateCalculator.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 05/09/2023.

import Foundation

final class ChangeRateService {

    var urlGenerator:ChangeRateUrlGenerator
    var session:URLSession
    var cache:ChangeRateCache

    init(urlGenerator:ChangeRateUrlGenerator, session: URLSession, cache: ChangeRateCache) {
        self.urlGenerator = urlGenerator
        self.session = session
        self.cache = cache
    }

    func calculate(amount:Double, callback: @escaping (Result<Double, K.changeRate.error>) -> Void) -> Void {
        let existingRates = cache.get(key: DateHelper.getTodayDateText())
        if let existingUsdRate = existingRates[K.changeRate.strings.targetCurrency] {
            callback(.success(amount * existingUsdRate))
            return
        }

        getNewRates(amount, callback)
    }

    private func getNewRates(_ amount: Double, _ callback: @escaping (Result<Double, K.changeRate.error>) -> Void) {
        let task = session.dataTask(with: urlGenerator.generateUrl()) { data, response, error in
            guard let data = data, error == nil else {
                callback(.failure(K.changeRate.error.commonError))
                return
            }
            do {
                let changeRate = try JSONDecoder().decode(ChangeRate.self, from: data)
                self.cache.set(key: changeRate.dateText, value: changeRate.rates)
                if let usdRate = changeRate.rates[K.changeRate.strings.targetCurrency] {
                    callback(.success(amount * usdRate))
                } else {
                    callback(.failure(K.changeRate.error.missingCurrency))
                }
            } catch {
                callback(.failure(K.changeRate.error.decodingError))
            }
        }
        task.resume()
    }
}
