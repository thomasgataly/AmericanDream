//
//  TranslatorUrlGenerator.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 26/09/2023.
//

import Foundation

class TranslationUrlGenerator {
    func generateUrl(text:String, source:String, target:String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "source", value: source),
            URLQueryItem(name: "target", value: target),
            URLQueryItem(name: "key", value: K.translator.api.apiKey)
        ]
        var request = URLRequest(url: URL(string: K.translator.api.endpoint)!)
        request.httpMethod = "POST"
        request.httpBody = urlComponents.percentEncodedQuery?.data(using: .utf8)

        return request
    }
}
