//
//  SearchParameters.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

struct SearchParameters {
    let page: Int
    let order: String
    let query: String?
    let category: Category?
    let colors: [ProductColor]?
    let materials: [ProductMaterial]?
    let conditions: [ProductCondition]?
    let minPrice: Int?
    let maxPrice: Int?
}
