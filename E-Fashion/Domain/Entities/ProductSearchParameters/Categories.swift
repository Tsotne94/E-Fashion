//
//  Categories.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

struct MainCategory {
    let id: Int
    let title: String
    var sections: [SectionType: SubcategorySection]
    
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
                .clothes: SubcategorySection(
                    id: 2050,
                    title: "Clothes",
                    parentId: 5,
                    type: .clothes,
                    items: [
                        Category(id: 1201, title: "Jeans", parentId: 1100),
                        Category(id: 1202, title: "Pants", parentId: 1100),
                        Category(id: 1203, title: "T-Shirts", parentId: 1100),
                        Category(id: 1204, title: "Shirts", parentId: 1100),
                        Category(id: 1205, title: "Jackets", parentId: 1100),
                        Category(id: 1206, title: "Blazers", parentId: 1100),
                        Category(id: 1207, title: "Shorts", parentId: 1100),
                        Category(id: 1208, title: "Sweaters", parentId: 1100),
                        Category(id: 1209, title: "Coats", parentId: 1100)
                    ]
                ),
                .shoes: SubcategorySection(
                    id: 1232,
                    title: "Shoes",
                    parentId: 5,
                    type: .shoes,
                    items: [
                        Category(id: 1660, title: "Sneakers", parentId: 1232),
                        Category(id: 1302, title: "Running Shoes", parentId: 1110),
                        Category(id: 1303, title: "Basketball Shoes", parentId: 1110),
                        Category(id: 1304, title: "Boots", parentId: 1110),
                        Category(id: 1305, title: "Hiking Boots", parentId: 1110),
                        Category(id: 1306, title: "Snow Boots", parentId: 1110)
                    ]
                ),
                .accessories: SubcategorySection(
                    id: 82,
                    title: "Accessories",
                    parentId: 5,
                    type: .accessories,
                    items: [
                        Category(id: 1501, title: "Belts", parentId: 1120),
                        Category(id: 1502, title: "Watches", parentId: 1120),
                        Category(id: 1503, title: "Jewelry", parentId: 1120),
                        Category(id: 1504, title: "Sunglasses", parentId: 1120)
                    ]
                )
            ]
        )
        
        self.women = MainCategory(
            id: 1904,
            title: "Women",
            sections: [
                .new: SubcategorySection(
                    id: 1904,
                    title: "New Items",
                    parentId: 1904,
                    type: .new,
                    items: []
                ),
                .clothes: SubcategorySection(
                    id: 4,
                    title: "Clothes",
                    parentId: 1904,
                    type: .clothes,
                    items: [
                        Category(id: 12, title: "Tops & T-Shirts", parentId: 4),
                        Category(id: 11, title: "Skirts", parentId: 4),
                        Category(id: 10, title: "Dresses", parentId: 4),
                        Category(id: 8, title: "Suits & Blazers", parentId: 4),
                        Category(id: 15, title: "Shorts", parentId: 4),
                        Category(id: 13, title: "Sweaters", parentId: 4),
                    ]
                ),
                .shoes: SubcategorySection(
                    id: 16,
                    title: "Shoes",
                    parentId: 1904,
                    type: .shoes,
                    items: [
                        Category(id: 215, title: "Slippers", parentId: 16),
                        Category(id: 543, title: "Heels", parentId: 16),
                        Category(id: 1049, title: "Boots", parentId: 16)
                    ]
                ),
                .accessories: SubcategorySection(
                    id: 1187,
                    title: "Accessories",
                    parentId: 1904,
                    type: .accessories,
                    items: [
                        Category(id: 19, title: "Bags", parentId: 1187),
                        Category(id: 20, title: "Belts", parentId: 1187),
                        Category(id: 21, title: "Jewelry", parentId: 1187),
                        Category(id: 22, title: "Watches", parentId: 1187),
                        Category(id: 26, title: "Sunglasses", parentId: 1187)
                    ]
                )
            ]
        )
        
        self.kids = MainCategory(
            id: 3000,
            title: "Kids",
            sections: [
                .clothes: SubcategorySection(
                    id: 3100,
                    title: "Clothes",
                    parentId: 3000,
                    type: .clothes,
                    items: [
                        Category(id: 3201, title: "Tops & T-Shirts", parentId: 3100),
                        Category(id: 3202, title: "Jeans", parentId: 3100),
                        Category(id: 3203, title: "Pants & Shorts", parentId: 3100),
                        Category(id: 3204, title: "Outerwear", parentId: 3100),
                        Category(id: 3205, title: "Dresses", parentId: 3100),
                        Category(id: 3206, title: "Skirts", parentId: 3100)
                    ]
                ),
                .shoes: SubcategorySection(
                    id: 3110,
                    title: "Shoes",
                    parentId: 3000,
                    type: .shoes,
                    items: [
                        Category(id: 3301, title: "Sneakers", parentId: 3110),
                        Category(id: 3302, title: "Boots", parentId: 3110)
                    ]
                ),
                .accessories: SubcategorySection(
                    id: 3120,
                    title: "Accessories",
                    parentId: 3000,
                    type: .accessories,
                    items: [
                        Category(id: 3401, title: "Bags & Backpacks", parentId: 3120),
                        Category(id: 3402, title: "Accessories", parentId: 3120)
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
        let mainCategory = getCategories(for: categoryType)
        
        guard let section = mainCategory.sections[sectionType] else {
            return nil
        }
        
        return section
    }
    
    func getItems(for categoryType: CategoryType, sectionType: SectionType) -> [Category] {
        guard let section = getSection(for: categoryType, sectionType: sectionType) else {
            return []
        }
        
        return section.items
    }
    
    func getItem(id: Int, categoryType: CategoryType, sectionType: SectionType) -> Category? {
        let items = getItems(for: categoryType, sectionType: sectionType)
        return items.first { $0.id == id }
    }
    
    func getSubcategoryItems(id: Int) -> [Category] {
        let allMainCategories = [men, women, kids]

        for mainCategory in allMainCategories {
            for section in mainCategory.sections.values {
                if section.id == id {
                    return section.items
                }
            }
        }
        return []
    }
}
