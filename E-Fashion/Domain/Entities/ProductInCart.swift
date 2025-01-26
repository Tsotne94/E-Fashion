//
//  ProductInCart.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 26.01.25.
//

struct ProductInCart: Codable {
    let id: String
    let product: ProductDetails
    var quantity: Int
}
