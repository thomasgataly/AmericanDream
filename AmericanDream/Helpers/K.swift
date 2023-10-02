//
//  Constants.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 14/09/2023.
//

import Foundation

struct K {

    struct common {
        static let ok = "OK"
    }

    struct changeRate {
        struct api {
            static let endpoint = "http://data.fixer.io/api/latest"
            static let apiKey = ProcessInfo.processInfo.environment["FIXER_IO_API_KEY"]
            static let apiKeyParameterName = "access_key"
        }
        struct strings {
            static let targetCurrency = "USD"
            static let requestAmount = "Veuillez saisir un montant"
            static let cta = "CALCULER"
        }
        enum error:String,Error {
            case missingCurrency = "Taux introuvable"
            case commonError = "Une erreur est survenue"
            case decodingError = "Données incorrectes"
        }
    }

    struct translator {
        struct api {
            static let endpoint = "https://translation.googleapis.com/language/translate/v2"
            static let apiKey = ProcessInfo.processInfo.environment["GOOGLE_API_KEY"]
        }
        struct strings {
            static let requestText = "Veuillez saisir un texte à traduire"
            static let cta = "TRADUIRE"
        }
        enum error:String,Error {
            case missingText = "Veuillez saisir un texte"
            case commonError = "Une erreur est survenue"
            case decodingError = "Données incorrectes"
        }
    }

    struct weather {
        struct api {
            static let endpoint = "https://api.openweathermap.org/data/2.5/weather"
            static let apiKey = ProcessInfo.processInfo.environment["OPEN_WEATHER_MAP_API_KEY"]
        }
        struct strings {
            static let requestCity = "Veuillez saisir le nom d'une ville"
            static let mainCity = "New York"
        }
        enum error:String,Error {
            case badRequest = "Veuillez saisir une ville"
            case notFoundCity = "Ville introuvable"
            case commonError = "Une erreur est survenue"
            case decodingError = "Données incorrectes"
        }
    }
}
