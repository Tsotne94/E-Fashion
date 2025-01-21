//
//  Category.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

struct Category: Codable, Identifiable {
    let id: Int
    let title: String
    let parentId: Int
    let parent: String
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case parentId = "parent_id"
        case parent
    }
}
