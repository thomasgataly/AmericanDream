//
//  InMemoryChangeRateCacheManager.swift
//  AmericanDreamTests
//
//  Created by Thomas Gataly on 19/09/2023.
//

import Foundation
@testable import AmericanDream

class InMemoryChangeRateCacheManager:ChangeRateCacheManager {

    public static var rates:[String:[String:Double]] = [:]

    override func load(key: String) -> [String:Double] {
        return InMemoryChangeRateCacheManager.rates[key] ?? [:]
    }

    override func save(key: String, value: [String:Double]) {
        InMemoryChangeRateCacheManager.rates = [key:value]
    }
}
