//
//  ChangeRate.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 05/09/2023.
//

struct ChangeRate: Decodable {
    let dateText: String
    let rates: [String:Double]

    enum CodingKeys: String, CodingKey {
        case dateText = "date"
        case rates
    }
}
