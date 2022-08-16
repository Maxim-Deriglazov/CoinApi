//
//  Structures.swift
//  coinApi
//
//  Created by Max on 02.08.2022.
//

import Foundation

struct arrRates: Codable {
    var time: String
    var assetIdQuote: String
    var rate: Float
}

struct IpResponse: Codable {
    var assetIdBase: String
    var rates: [arrRates]
}

struct Exchangerate: Codable {
    var time: String
    var assetIdBase: String
    var assetIdQuote: String
    var rate: Float
}
