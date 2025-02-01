//
//  Product.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

public struct Product: Codable, Equatable {
    let productId: Int
    let title: String
    let url: String
    let image: String
    let promoted: Bool
    let favourites: Int
    let brand: String?
    let size: String?
    let price: Price
    let seller: Seller
    
    public static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.productId == rhs.productId
    }
}
