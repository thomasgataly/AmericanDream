//
//  HTTPClient.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 26/09/2023.
//

import Foundation

protocol HTTPClient {
    func data(from url: URL) async throws -> (Data, HTTPURLResponse)
}
