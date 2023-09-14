//
//  ChangeRateCalculator.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 05/09/2023.
//

import Foundation
import CoreData

final class ChangeRateCalculator {

    private let url = URL(string: "http://data.fixer.io/api/latest?access_key=5157f49dc267682e93a11cd4c11b8371")!

    func calculate(amount:Float, callback: @escaping (Float?) -> Void ) -> Void {
        let existingRates = getExistingRates()
        if existingRates.count > 0 {
            DispatchQueue.main.async {
                callback(amount * existingRates[0].rate)
            }
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

    private func getNewRates(_ amount: Float, _ callback: @escaping (Float?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let changeRate = try JSONDecoder().decode(ChangeRateDecodable.self, from: data)
                    for rate in changeRate.rates {
                        self.saveRate(dateText: changeRate.dateText, country: rate.key, rateValue: rate.value)
                    }
                    if let usdRate = changeRate.rates["USD"] {
                        DispatchQueue.main.async {
                            callback(amount * usdRate)
                        }
                    }
                } catch {
                    print(error)
                }
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
