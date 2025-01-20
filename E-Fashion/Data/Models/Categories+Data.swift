//
//  Categories+Data.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

extension Categories {
    static let allCategories = Categories(
        men: [
            Category(id: 32, title: "Suits & Blazers", parentId: 2050, parent: "Clothes"),
            Category(id: 34, title: "Pants", parentId: 2050, parent: "Clothes"),
            Category(id: 80, title: "Shorts", parentId: 2050, parent: "Clothes"),
            Category(id: 79, title: "Jumpers & Sweaters", parentId: 2050, parent: "Clothes"),
            Category(id: 84, title: "Swimwear", parentId: 2050, parent: "Clothes"),
            Category(id: 85, title: "Socks & Underwear", parentId: 2050, parent: "Clothes"),
            Category(id: 76, title: "Tops & T-Shirts", parentId: 2050, parent: "Clothes"),
            Category(id: 257, title: "Jeans", parentId: 2050, parent: "Clothes"),
            Category(id: 83, title: "Other Men's Clothing", parentId: 2050, parent: "Clothes"),
            Category(id: 92, title: "Costumes & Special Outfits", parentId: 2050, parent: "Clothes")
        ],
        women: [
            Category(id: 8, title: "Suits & Blazers", parentId: 4, parent: "Clothes"),
            Category(id: 9, title: "Pants & Leggings", parentId: 4, parent: "Clothes"),
            Category(id: 10, title: "Dresses", parentId: 4, parent: "Clothes"),
            Category(id: 11, title: "Skirts", parentId: 4, parent: "Clothes"),
            Category(id: 12, title: "Tops & T-Shirts", parentId: 4, parent: "Clothes"),
            Category(id: 13, title: "Jumpers & Sweaters", parentId: 4, parent: "Clothes"),
            Category(id: 28, title: "Swimwear", parentId: 4, parent: "Clothes"),
            Category(id: 29, title: "Lingerie & Nightwear", parentId: 4, parent: "Clothes"),
            Category(id: 15, title: "Shorts & Cropped Pants", parentId: 4, parent: "Clothes"),
            Category(id: 73, title: "Activewear", parentId: 4, parent: "Clothes")
        ],
        kids: [
            Category(id: 218, title: "One-pieces", parentId: 28, parent: "Swimwear"),
            Category(id: 219, title: "Bikinis & Tankinis", parentId: 28, parent: "Swimwear"),
            Category(id: 220, title: "Other Swimwear & Beachwear", parentId: 28, parent: "Swimwear"),
            Category(id: 287, title: "Caps", parentId: 86, parent: "Hats & Caps"),
            Category(id: 289, title: "Winter Hats", parentId: 86, parent: "Hats & Caps")
        ]
    )
}
