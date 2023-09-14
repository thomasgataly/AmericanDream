//
//  String+capitalizedSentence.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 14/09/2023.
//

extension String {
    var capitalizedSentence: String {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst().lowercased()
        return firstLetter + remainingLetters
    }
}
