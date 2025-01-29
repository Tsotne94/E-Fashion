//
//  ProductInCart.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 26.01.25.
//
import Foundation

struct ProductInCart: Codable {
    let id: String
    let product: ProductDetails
    var quantity: Int
    let timestamp: Date
    
    init(id: String, product: ProductDetails, quantity: Int) {
        self.id = id
        self.product = product
        self.quantity = quantity
        self.timestamp = Date()
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case product
        case quantity
        case timestamp
    }
}
