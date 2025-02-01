//
//  Price+DiscountAsDouble.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 21.01.25.
//

public extension Product {
    var discountPercentage: Double {
        guard let originalPrice = Double(price.amount.amount),
              let discountedPrice = Double(price.totalAmount.amount),
              originalPrice > 0 else {
            return 0
        }
        return ((originalPrice - discountedPrice) / originalPrice) * 100
    }
}
