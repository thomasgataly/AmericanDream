//
//  Translator.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 14/09/2023.
//

import Foundation

final class Translator {

    static let url = URL(string: "https://translation.googleapis.com/language/translate/v2")!
    private static let key = "AIzaSyAB-ZcaAgzs36sT8EWFViBE6A-yOXFg-xU"

    static func translate(_ text: String, _ callback: @escaping (String?) -> Void) {
        var request = URLRequest(url: self.url)
        request.httpMethod = "POST"
        let body = "q=\(text)&source=fr&target=en&key=\(self.key)"
        request.httpBody = body.data(using: .utf8)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let translation = try JSONDecoder().decode(TranslationDecodable.self, from: data)
                    DispatchQueue.main.async {
                        callback(translation.data.translations[0].translatedText)
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
}