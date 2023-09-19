//
//  Constants.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 14/09/2023.
//

struct K {
    struct changeRateApi {
        static let endpoint = "http://data.fixer.io/api/latest?access_key=5157f49dc267682e93a11cd4c11b8371"
        static let apiKey = "5157f49dc267682e93a11cd4c11b8371"
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
        static let apiKey = "AIzaSyAB-ZcaAgzs36sT8EWFViBE6A-yOXFg-xU"
    }

    struct weatherApi {
        static let endpoint = "https://api.openweathermap.org/data/2.5/weather"
        static let apiKey = "71819d34f088ab38323f1d41880f292a"
        enum error:String,Error {
            case missingCity = "Veuillez saisir une ville"
            case notFoundCity = "Ville introuvable"
            case commonError = "Une erreur est survenue"
            case decodingError = "Données incorrectes"
        }
    }
}
