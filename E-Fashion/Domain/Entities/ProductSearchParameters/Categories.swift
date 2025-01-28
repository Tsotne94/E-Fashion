//
//  Categories.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

struct MainCategory {
    let id: Int
    let title: String
    private let sections: [SectionType: SubcategorySection]
    
    init(id: Int, title: String, sections: [SectionType: SubcategorySection]) {
        self.id = id
        self.title = title
        self.sections = sections
    }
    
    func getSection(_ type: SectionType) -> SubcategorySection? {
        return sections[type]
    }
    
    func getItems(_ type: SectionType) -> [Category] {
        return sections[type]?.items ?? []
    }
}


class Categories {
    let men: MainCategory
    let women: MainCategory
    let kids: MainCategory
    
    init() {
        self.men = MainCategory(
            id: 5,
            title: "Men",
            sections: [
                .new: SubcategorySection(
                    id: 101,
                    title: "New",
                    parentId: 5,
                    type: .new,
                    items: []
                ),
                .clothes: SubcategorySection(
                    id: 102,
                    title: "Clothes",
                    parentId: 5,
                    type: .clothes,
                    items: [
                        Category(id: 183, title: "Jeans", parentId: 2050),
                        Category(id: 34, title: "Pants", parentId: 2050),
                        Category(id: 221, title: "T-shirts", parentId: 2050),
                        Category(id: 536, title: "Shirts", parentId: 2050),
                        Category(id: 2052, title: "Jackets", parentId: 2050),
                        Category(id: 532, title: "Blazers", parentId: 8),
                        Category(id: 80, title: "Shorts", parentId: 2050),
                        Category(id: 79, title: "Sweaters", parentId: 2050),
                        Category(id: 2051, title: "Coats", parentId: 2050)
                    ]
                ),
                .shoes: SubcategorySection(
                    id: 103,
                    title: "Shoes",
                    parentId: 5,
                    type: .shoes,
                    items: [
                        Category(id: 1231, title: "Shoes", parentId: 5),
                        Category(id: 1242, title: "Sneakers", parentId: 1231),
                        Category(id: 1238, title: "Formal Shoes", parentId: 1231),
                        Category(id: 1233, title: "Boots", parentId: 1231)
                    ]
                ),
                .accessories: SubcategorySection(
                    id: 104,
                    title: "Accessories",
                    parentId: 5,
                    type: .accessories,
                    items: [
                        Category(id: 20, title: "Belts", parentId: 1187),
                        Category(id: 22, title: "Watches", parentId: 1187),
                        Category(id: 21, title: "Jewelry", parentId: 1187),
                        Category(id: 26, title: "Sunglasses", parentId: 1187)
                    ]
                )
            ]
        )
        
        self.women = MainCategory(
            id: 4,
            title: "Women",
            sections: [
                .new: SubcategorySection(
                    id: 105,
                    title: "New",
                    parentId: 4,
                    type: .new,
                    items: []
                ),
                .clothes: SubcategorySection(
                    id: 106,
                    title: "Clothes",
                    parentId: 4,
                    type: .clothes,
                    items: [
                        Category(id: 257, title: "Jeans", parentId: 4),
                        Category(id: 12, title: "Tops & T-shirts", parentId: 4),
                        Category(id: 9, title: "Pants & Leggings", parentId: 4),
                        Category(id: 11, title: "Skirts", parentId: 4),
                        Category(id: 1908, title: "Jackets", parentId: 4),
                        Category(id: 8, title: "Blazers", parentId: 4),
                        Category(id: 15, title: "Shorts", parentId: 4),
                        Category(id: 13, title: "Sweaters", parentId: 4),
                        Category(id: 1907, title: "Coats", parentId: 4)
                    ]
                ),
                .shoes: SubcategorySection(
                    id: 107,
                    title: "Shoes",
                    parentId: 4,
                    type: .shoes,
                    items: [
                        Category(id: 16, title: "Shoes", parentId: 4),
                        Category(id: 1909, title: "Flats", parentId: 4),
                        Category(id: 543, title: "Heels", parentId: 4),
                        Category(id: 1049, title: "Boots", parentId: 4)
                    ]
                ),
                .accessories: SubcategorySection(
                    id: 108,
                    title: "Accessories",
                    parentId: 4,
                    type: .accessories,
                    items: [
                        Category(id: 19, title: "Bags", parentId: 4),
                        Category(id: 20, title: "Belts", parentId: 1187),
                        Category(id: 21, title: "Jewelry", parentId: 1187),
                        Category(id: 22, title: "Watches", parentId: 1187),
                        Category(id: 26, title: "Sunglasses", parentId: 1187)
                    ]
                )
            ]
        )
        
        self.kids = MainCategory(
            id: 1193,
            title: "Kids",
            sections: [
                .new: SubcategorySection(
                    id: 109,
                    title: "New",
                    parentId: 1193,
                    type: .new,
                    items: []
                ),
                .clothes: SubcategorySection(
                    id: 110,
                    title: "Clothes",
                    parentId: 1193,
                    type: .clothes,
                    items: [
                        Category(id: 1198, title: "Tops & T-shirts", parentId: 1193),
                        Category(id: 1696, title: "Jeans", parentId: 1193),
                        Category(id: 1200, title: "Pants & Shorts", parentId: 1193),
                        Category(id: 1197, title: "Outerwear", parentId: 1193),
                        Category(id: 1199, title: "Sweaters & Hoodies", parentId: 1193),
                        Category(id: 1247, title: "Dresses", parentId: 1193),
                        Category(id: 1248, title: "Skirts", parentId: 1193)
                    ]
                ),
                .shoes: SubcategorySection(
                    id: 111,
                    title: "Shoes",
                    parentId: 1193,
                    type: .shoes,
                    items: [
                        Category(id: 1255, title: "Shoes", parentId: 1193),
                        Category(id: 1201, title: "Shorts & Cropped Pants", parentId: 1193)
                    ]
                ),
                .accessories: SubcategorySection(
                    id: 112,
                    title: "Accessories",
                    parentId: 1193,
                    type: .accessories,
                    items: [
                        Category(id: 1258, title: "Bags & Backpacks", parentId: 1193),
                        Category(id: 1574, title: "Accessories", parentId: 1195)
                    ]
                )
            ]
        )
    }
    
    func getCategories(for type: CategoryType) -> MainCategory {
        switch type {
        case .men: return men
        case .women: return women
        case .kids: return kids
        }
    }
    
    func getSection(for categoryType: CategoryType, sectionType: SectionType) -> SubcategorySection? {
        return getCategories(for: categoryType).getSection(sectionType)
    }
    
    func getItems(for categoryType: CategoryType, sectionType: SectionType) -> [Category] {
        return getCategories(for: categoryType).getItems(sectionType)
    }
}
