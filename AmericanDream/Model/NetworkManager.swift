//
//  NetworkManager.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 15/09/2023.
//

import Foundation

class NetworkManager {
    var url:URL
    var session:URLSession
    var apiKey:String?

    init(url: URL, session: URLSession, apiKey: String?) {
        self.url = url
        self.session = session
        self.apiKey = apiKey
    }
}
