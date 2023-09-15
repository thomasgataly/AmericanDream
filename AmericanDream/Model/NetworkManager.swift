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

    init(url: URL, session: URLSession) {
        self.url = url
        self.session = session
    }
}
