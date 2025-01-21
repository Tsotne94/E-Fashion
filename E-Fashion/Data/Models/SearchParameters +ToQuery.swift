//
//  SearchParameters +ToQuery.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

import Foundation

extension SearchParameters {
    func toQueryItems() -> [URLQueryItem] {
        var items = [
            URLQueryItem(name: "country", value: "us"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "order", value: order.rawValue)
        ]
        
        if let query = query {
            items.append(URLQueryItem(name: "keyword", value: query))
        }
        
        if let category = category {
            items.append(URLQueryItem(name: "category", value: "\(category.id)"))
        }
        
        if let colors = colors, !colors.isEmpty {
            let colorIds = colors.map { String($0.id) }.joined(separator: ",")
            items.append(URLQueryItem(name: "colors", value: colorIds))
        }
        
        if let materials = materials, !materials.isEmpty {
            let materialIds = materials.map { String($0.id) }.joined(separator: ",")
            items.append(URLQueryItem(name: "materials", value: materialIds))
        }
        
        if let conditions = conditions, !conditions.isEmpty {
            let conditionIds = conditions.map { String($0.id) }.joined(separator: ",")
            items.append(URLQueryItem(name: "conditions", value: conditionIds))
        }
        
        if let minPrice = minPrice {
            items.append(URLQueryItem(name: "minPrice", value: "\(minPrice)"))
        }
        
        if let maxPrice = maxPrice {
            items.append(URLQueryItem(name: "maxPrice", value: "\(maxPrice)"))
        }
        
        return items
    }
}
