//
//  TranslatorUrlGeneratorFake.swift
//  AmericanDreamTests
//
//  Created by Thomas Gataly on 26/09/2023.
//

import Foundation
@testable import AmericanDream

class TranslationServiceUrlGeneratorFake: TranslationUrlGenerator {
    var url: URL
    init(url: URL) {
        self.url = url
    }

    override func generateUrl(text:String, source:String, target:String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        return request
    }
}
