//
//  OrderType.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 21.01.25.
//
import Foundation

enum OrderType: String, Codable {
    case relevance = "relevance"
    case priceHighToLow = "price_high_to_low"
    case priceLowToHigh = "price_low_to_high"
    case newestFirst = "newest_first"
}
