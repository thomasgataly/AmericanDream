//
//  TranslationDecodable.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 14/09/2023.
//


struct Translation: Decodable {
    let data: Translations

    struct Translations:Decodable {
        let translations: [Translation]
    }

    struct Translation:Decodable {
        let translatedText: String
    }
}
