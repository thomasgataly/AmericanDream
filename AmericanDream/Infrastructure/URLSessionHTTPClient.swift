//
//  URLSessionHTTPClient.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 26/09/2023.
//

import Foundation

final class URLSessionHTTPClient: HTTPClient {

    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func data(from url: URL) async throws -> (Data, HTTPURLResponse) {
        guard let (data, response) = try? await session.data(from: url),
              let response = response as? HTTPURLResponse else {
            throw URLError(.notConnectedToInternet)
        }
        return (data, response)
    }
}
