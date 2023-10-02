//
//  URLProtocolStub.swift
//  AmericanDreamTests
//
//  Created by Thomas Gataly on 18/09/2023.
//

import Foundation

class URLProtocolStub: URLProtocol {
    // these dictionaries maps URLs to test data, response and error
    static var data = [URL?: Data]()
    static var response = [URL?: URLResponse]()
    static var error = [URL?: Error]()

    // say we want to handle all types of request
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    // ignore this method; just send back what we were given
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        // if we have a valid URL…
        if let url = request.url {
            // …and if we have test data or error for that URL…
            if let data = URLProtocolStub.data[url] {
                // …load it immediately.
                self.client?.urlProtocol(self, didLoad: data)
            }
            if let error = URLProtocolStub.error[url] {
                // …load it immediately.
                self.client?.urlProtocol(self, didFailWithError: error)
            }
            if let response = URLProtocolStub.response[url] {
                // …load it immediately.
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
        }

        // mark that we've finished
        self.client?.urlProtocolDidFinishLoading(self)
    }

    // this method is required but doesn't need to do anything
    override func stopLoading() { }
}
