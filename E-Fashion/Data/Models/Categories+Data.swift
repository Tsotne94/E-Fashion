//
//  Categories+Data.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

extension Categories {
    static let menId = 5
    static let womenId = 4
    static let kidsId = 1193
    
    static let allMenIds = [183, 34, 221, 536, 2052, 532, 80, 79, 2051, 1231]
    static let allWomenIds = [257, 12, 9, 11, 1908, 8, 15, 13, 1907, 16]
    static let allKidsIds = [1198, 1696, 1200, 1197, 1199, 1247, 1248, 1255, 1258, 1201]
    
    static let allCategories = Categories(
        men: [
            Category(id: 183, title: "Jeans", parentId: 5, parent: "Men"),
            Category(id: 34, title: "Pants", parentId: 5, parent: "Men"),
            Category(id: 221, title: "T-shirts", parentId: 5, parent: "Men"),
            Category(id: 536, title: "Shirts", parentId: 5, parent: "Men"),
            Category(id: 2052, title: "Jackets", parentId: 5, parent: "Men"),
            Category(id: 532, title: "Blazers", parentId: 5, parent: "Men"),
            Category(id: 80, title: "Shorts", parentId: 5, parent: "Men"),
            Category(id: 79, title: "Sweaters", parentId: 5, parent: "Men"),
            Category(id: 2051, title: "Coats", parentId: 5, parent: "Men"),
            Category(id: 1231, title: "Shoes", parentId: 5, parent: "Men")
        ],
        women: [
            Category(id: 257, title: "Jeans", parentId: 4, parent: "Women"),
            Category(id: 12, title: "Tops & T-shirts", parentId: 4, parent: "Women"),
            Category(id: 9, title: "Pants & Leggings", parentId: 4, parent: "Women"),
            Category(id: 11, title: "Skirts", parentId: 4, parent: "Women"),
            Category(id: 1908, title: "Jackets", parentId: 4, parent: "Women"),
            Category(id: 8, title: "Blazers", parentId: 4, parent: "Women"),
            Category(id: 15, title: "Shorts", parentId: 4, parent: "Women"),
            Category(id: 13, title: "Sweaters", parentId: 4, parent: "Women"),
            Category(id: 1907, title: "Coats", parentId: 4, parent: "Women"),
            Category(id: 16, title: "Shoes", parentId: 4, parent: "Women")
        ],
        kids: [
            Category(id: 1198, title: "Tops & T-shirts", parentId: 1193, parent: "Kids"),
            Category(id: 1696, title: "Jeans", parentId: 1193, parent: "Kids"),
            Category(id: 1200, title: "Pants & Shorts", parentId: 1193, parent: "Kids"),
            Category(id: 1197, title: "Outerwear", parentId: 1193, parent: "Kids"),
            Category(id: 1199, title: "Sweaters & Hoodies", parentId: 1193, parent: "Kids"),
            Category(id: 1247, title: "Dresses", parentId: 1193, parent: "Kids"),
            Category(id: 1248, title: "Skirts", parentId: 1193, parent: "Kids"),
            Category(id: 1255, title: "Shoes", parentId: 1193, parent: "Kids"),
            Category(id: 1258, title: "Bags & Backpacks", parentId: 1193, parent: "Kids"),
            Category(id: 1201, title: "Shorts & Cropped Pants", parentId: 1193, parent: "Kids")
        ]
    )
}
