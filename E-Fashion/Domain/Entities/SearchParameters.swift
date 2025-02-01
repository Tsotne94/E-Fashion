//
//  SearchParameters.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

public final class SearchParameters {
    var page: Int
    var order: OrderType
    var query: String?
    var category: Category?
    var colors: [ProductColor]?
    var materials: [ProductMaterial]?
    var conditions: [ProductCondition]?
    var minPrice: Int?
    var maxPrice: Int?
    
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
