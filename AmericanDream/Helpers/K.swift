//
//  Constants.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 14/09/2023.
//

import Foundation

struct K {
    struct changeRateApi {
        static let endpoint = "http://data.fixer.io/api/latest"
        static let apiKey = ProcessInfo.processInfo.environment["FIXER_IO_API_KEY"]
        static let apiKeyParameterName = "access_key"
        static let targetCurrency = "USD"
        enum error:String,Error {
            case missingCurrency = "Taux introuvable"
            case commonError = "Une erreur est survenue"
            case decodingError = "Données incorrectes"
        }
    }

    struct translatorApi {
        static let endpoint = "https://translation.googleapis.com/language/translate/v2"
        static let apiKey = ProcessInfo.processInfo.environment["GOOGLE_API_KEY"]
    }

    struct weatherApi {
        static let endpoint = "https://api.openweathermap.org/data/2.5/weather"
        static let apiKey = ProcessInfo.processInfo.environment["OPEN_WEATHER_MAP_API_KEY"]
        enum error:String,Error {
            case missingCity = "Veuillez saisir une ville"
            case notFoundCity = "Ville introuvable"
            case commonError = "Une erreur est survenue"
            case decodingError = "Données incorrectes"
        }
    }
}
