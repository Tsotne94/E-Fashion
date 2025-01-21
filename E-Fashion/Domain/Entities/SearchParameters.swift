//
//  SearchParameters.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

struct SearchParameters {
    let page: Int
    let order: OrderType
    let query: String?
    let category: Category?
    let colors: [ProductColor]?
    let materials: [ProductMaterial]?
    let conditions: [ProductCondition]?
    let minPrice: Int?
    let maxPrice: Int?
    
    init(page: Int, order: OrderType, query: String? = nil, category: Category? = nil, colors: [ProductColor]? = nil, materials: [ProductMaterial]? = nil, conditions: [ProductCondition]? = nil, minPrice: Int? = nil, maxPrice: Int? = nil) {
        self.page = page
        self.order = order
        self.query = query
        self.category = category
        self.colors = colors
        self.materials = materials
        self.conditions = conditions
        self.minPrice = minPrice
        self.maxPrice = maxPrice
    }
}
