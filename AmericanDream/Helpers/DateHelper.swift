//
//  DateHelper.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 19/09/2023.
//

import Foundation

class DateHelper {
    static func getTodayDateText() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
}
