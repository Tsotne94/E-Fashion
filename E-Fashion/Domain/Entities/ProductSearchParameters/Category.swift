//
//  Category.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

public struct Category: Codable, Identifiable {
    public let id: Int
    let title: String
    let parentId: Int
    let parent: String
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case parentId = "parent_id"
        case parent
    }
    
    public init(id: Int, title: String = "", parentId: Int = 0, parent: String = "") {
        self.id = id
        self.title = title
        self.parentId = parentId
        self.parent = parent
    }
}
