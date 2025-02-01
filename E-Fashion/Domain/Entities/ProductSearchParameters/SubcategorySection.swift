//
//  SubcategorySection.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 29.01.25.
//

public struct SubcategorySection {
    let id: Int
    let title: String
    let parentId: Int
    let type: SectionType
    let items: [Category]
}
