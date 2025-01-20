//
//  File.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

extension Categories {
    func getCategories(for type: CategoryType) -> [Category] {
        switch type {
        case .men:
            return men
        case .women:
            return women
        case .kids:
            return kids
        }
    }
    
    func findCategory(id: Int) -> Category? {
        men.first { $0.id == id } ??
        women.first { $0.id == id } ??
        kids.first { $0.id == id }
    }
    
    func findCategories(parent: String) -> [Category] {
        men.filter { $0.parent == parent } +
        women.filter { $0.parent == parent } +
        kids.filter { $0.parent == parent }
    }
}
