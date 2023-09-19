//
//  Translator.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 14/09/2023.
//

import Foundation

final class Translator:NetworkManager {

    func translate(text: String, source:String, target:String, _ callback: @escaping (Result<String, NetworkError>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "source", value: source),
            URLQueryItem(name: "target", value: target),
            URLQueryItem(name: "key", value: K.translatorApi.apiKey)
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = urlComponents.percentEncodedQuery?.data(using: .utf8)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                callback(.failure(NetworkError.commonError))
                return
            }

            do {
                let translation = try JSONDecoder().decode(Translation.self, from: data)
                callback(.success(translation.data.translations[0].translatedText))
            } catch {
                callback(.failure(NetworkError.decodingError))
            }
        }
        task.resume()
    }
}
