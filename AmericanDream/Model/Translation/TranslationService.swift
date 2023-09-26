//
//  Translator.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 14/09/2023.
//

import Foundation

final class TranslationService {

    var urlGenerator:TranslationUrlGenerator
    var session:URLSession

    init(urlGenerator: TranslationUrlGenerator, session: URLSession) {
        self.urlGenerator = urlGenerator
        self.session = session
    }

    func translate(text: String, source:String, target:String, _ callback: @escaping (Result<String, K.weather.error>) -> Void) {
        let request = urlGenerator.generateUrl(text: text, source: source, target: target)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return callback(.failure(K.weather.error.commonError))
            }
            do {
                let translation = try JSONDecoder().decode(Translation.self, from: data)
                callback(.success(translation.data.translations[0].translatedText))
            } catch {
                callback(.failure(K.weather.error.decodingError))
            }
        }
        task.resume()
    }
}
