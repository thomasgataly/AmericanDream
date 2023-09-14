//
//  ChangeRate.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 05/09/2023.
//

struct ChangeRateDecodable: Decodable {
    let dateText: String
    let rates: [String:Float]

    enum CodingKeys: String, CodingKey {
        case dateText = "date"
        case rates
    }
}