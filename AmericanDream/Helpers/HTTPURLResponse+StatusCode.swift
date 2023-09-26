//
//  HTTPURLResponse+StatusCode.swift
//  AmericanDream
//
//  Created by Thomas Gataly on 26/09/2023.
//

import Foundation

extension HTTPURLResponse {
    private static var Ok200: Int { 200 }

    var isOK: Bool { statusCode == HTTPURLResponse.Ok200 }
}
