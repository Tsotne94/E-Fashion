//
//  FavouriteProduct.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 30.01.25.
//

import Foundation

public struct FavouriteProduct: Codable {
    let id: String
    let product: Product
    let timestamp: Date
    
    public init(id: String, product: Product) {
        self.id = "\(product.productId)"
        self.product = product
        self.timestamp = Date()
    }
}
