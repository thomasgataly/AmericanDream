//
//  XCTestCase+readLocalJSONFile.swift
//  AmericanDreamTests
//
//  Created by Thomas Gataly on 26/09/2023.
//

import XCTest

extension XCTestCase {
    func readLocalJSONFile(forName name: String, fromClass className: AnyClass) -> Data? {
        let bundle = Bundle(for: className)
        let url = bundle.url(forResource: name, withExtension: "json")!
        return try! Data(contentsOf: url)
    }
}
