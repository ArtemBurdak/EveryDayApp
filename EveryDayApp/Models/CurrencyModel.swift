//
//  CurrencyModel.swift
//  EveryDayApp
//
//  Created by Artem on 3/4/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import Foundation

struct Currency: Codable {
    let success: Bool
    let terms: String
    let privacy: String
    let sourse = "USD"
    let quotes: QuotesCurrency
}

struct QuotesCurrency: Codable {
    var USDUAH: Double
    var USDEUR: Double
    var USDRUB: Double
}
