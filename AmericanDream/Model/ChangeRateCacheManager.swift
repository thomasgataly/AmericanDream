//
//  ChangeRateCacheManager.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 19/09/2023.
//

import Foundation

class ChangeRateCacheManager {
    func load(key:String) -> [String:Float] {
        return UserDefaults.standard.object(forKey: key) as? [String:Float] ?? [:]
    }

    func save(key:String, value:[String:Float]) {
        UserDefaults.standard.set(value, forKey: key)
    }
}
