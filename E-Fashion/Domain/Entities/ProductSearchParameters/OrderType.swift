//
//  OrderType.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 21.01.25.
//

enum OrderType: String, Codable, CaseIterable {
    case relevance = "Relevance"
    case priceHighToLow = "Price: High to Low"
    case priceLowToHigh = "Price: Low to High"
    case newestFirst = "Newest First"
}
