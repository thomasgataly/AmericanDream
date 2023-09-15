//
//  NetworkError.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 15/09/2023.
//

enum NetworkError:String,Error {
    case decodingError = "Données incorrectes"
    case commonError = "Opération momentanément indisponible"
}
