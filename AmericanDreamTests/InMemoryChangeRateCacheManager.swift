//
//  InMemoryChangeRateCacheManager.swift
//  AmericanDreamTests
//
//  Created by Thomas Gataly on 19/09/2023.
//

import Foundation
@testable import AmericanDream

class InMemoryChangeRateCacheManager:ChangeRateCacheManager {

    public static var rates:[String:[String:Float]] = [:]

    override func load(key: String) -> [String:Float] {
        return InMemoryChangeRateCacheManager.rates[key] ?? [:]
    }

    override func save(key: String, value: [String:Float]) {
        InMemoryChangeRateCacheManager.rates = [key:value]
    }
}
