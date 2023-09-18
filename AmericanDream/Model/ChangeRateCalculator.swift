//
//  ChangeRateCalculator.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 05/09/2023.
//

import Foundation
import CoreData

enum ChangeRateCalculatorError:String,Error {
    case missingCurrency = "Taux introuvable"
    case commonError = "Une erreur est survenue"
    case decodingError = "Données incorrectes"
}

final class ChangeRateCalculator {

    var url = URL(string: Constants.changeRateApi.endpoint)!
    var session:URLSession

    init(session: URLSession) {
        self.session = session
    }

    func calculate(amount:Float, callback: @escaping (Result<Float, ChangeRateCalculatorError>) -> Void) -> Void {
        let existingRates = getExistingRates()
        if existingRates.count > 0 {
            callback(.success(amount * existingRates[0].rate))
            return
        }

        getNewRates(amount, callback)
    }

    private func getExistingRates() -> [Rate] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDateText = dateFormatter.string(from: Date())

        let dateTextPredicate = NSPredicate(format: "dateText = %@", todayDateText)
        let countryPredicate = NSPredicate(format: "country = %@", "USD")
        let request: NSFetchRequest<Rate> = Rate.fetchRequest()
        request.predicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [
                dateTextPredicate,
                countryPredicate
            ]
        )
        guard let rates = try? CoreDataStack.shared.viewContext.fetch(request) else { return [] }

        return rates
    }

    private func getNewRates(_ amount: Float, _ callback: @escaping (Result<Float, ChangeRateCalculatorError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.url?.append(queryItems: [URLQueryItem(name: "access_key", value: Constants.changeRateApi.apiKey)])
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                callback(.failure(ChangeRateCalculatorError.commonError))
                return
            }

            do {
                let changeRate = try JSONDecoder().decode(ChangeRate.self, from: data)
                for rate in changeRate.rates {
                    self.saveRate(dateText: changeRate.dateText, country: rate.key, rateValue: rate.value)
                }
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

    private func saveRate(dateText: String, country:String, rateValue: Float) {
        let rate = Rate(context: CoreDataStack.shared.viewContext)
        rate.dateText = dateText
        rate.country = country
        rate.rate = rateValue
        do {
            try CoreDataStack.shared.viewContext.save()
        } catch {
            print("Fail to save rate")
        }
    }
    
}
