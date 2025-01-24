//
//  ProductDetails.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 21.01.25.
//

struct ProductDetails: Codable {
    let productId: Int
    let title: String
    let url: String
    let description: String
    let promoted: Bool
    let createdAt: String
    let lastUpdated: String
    let favourites: Int
    let size: Size
    let condition: ConditionDetails
    let color: ColorDetails
    let images: [String]
    let category: CategoryDetails
    let fullCategory: String
    let brand: Brand
    let price: PriceDetails
    let seller: DetailSeller
}
