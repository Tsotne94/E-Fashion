//
//  Product.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

struct Product: Codable {
    let productId: Int
    let title: String
    let url: String
    let image: String
    let promoted: Bool
    let favourites: Int
    let brand: String
    let size: String
    let price: Price
    let seller: Seller
    let isSold: Bool?
    let status: String
}
