//
//  OrderType.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 21.01.25.
//

public enum OrderType: String, Codable, CaseIterable {
    case relevance = "relevance"
    case priceHighToLow = "price_high_to_low"
    case priceLowToHigh = "price_low_to_high"
    case newestFirst = "newest_first"
    
    public func name() -> String {
        switch self {
        case .relevance:
            return "Relevance"
        case .priceHighToLow:
            return "Price: High to Low"
        case .priceLowToHigh:
            return "Price: Low to High"
        case .newestFirst:
            return "Newest First"
        }
    }
}
