//
//  ChangeRateCacheManager.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 19/09/2023.
//

import Foundation

class ChangeRateCacheManager {

    func load(key:String) -> [String:Double] {
        return UserDefaults.standard.object(forKey: key) as? [String:Double] ?? [:]
    }

    func save(key:String, value:[String:Double]) {
        UserDefaults.standard.set(value, forKey: key)
    }
}
