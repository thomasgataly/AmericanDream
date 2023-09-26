//
//  ChangeRateCalculator.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 05/09/2023.

import Foundation

final class ChangeRateCalculator {

    private let client: HTTPClient
    private let urlGenerator: ChangeRateCalculatorUrlGenerator
    private let cache: ChangeRateCacheManager

    init(client: HTTPClient, urlGenerator: ChangeRateCalculatorUrlGenerator, cache: ChangeRateCacheManager) {
        self.client = client
        self.urlGenerator = urlGenerator
        self.cache = cache
    }

    func calculate(amount: Double, callback: @escaping (Result<Double, K.changeRateApi.error>) -> Void) async -> Void {
        let existingRates = cache.get(key: DateHelper.getTodayDateText())
        if let existingUsdRate = existingRates[K.changeRateApi.targetCurrency] {
            callback(.success(amount * existingUsdRate))
            return
        }

        await getNewRates(amount, callback)
    }

    private func getNewRates(_ amount: Double, _ callback: @escaping (Result<Double, K.changeRateApi.error>) -> Void) async {
        do {
            let (data, response) = try await client.data(from: urlGenerator.generateUrl())
            DispatchQueue.main.async {
                guard response.isOK, let changeRate = try? JSONDecoder().decode(ChangeRate.self, from: data) else {
                    callback(.failure(K.changeRateApi.error.decodingError))
                    return
                }
                self.cache.set(key: changeRate.dateText, value: changeRate.rates)
                if let usdRate = changeRate.rates[K.changeRateApi.targetCurrency] {
                    callback(.success(amount * usdRate))
                } else {
                    callback(.failure(K.changeRateApi.error.missingCurrency))
                }
            }
        } catch {
            callback(.failure(K.changeRateApi.error.commonError))
        }
    }
}
