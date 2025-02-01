//
//  Category+Detils.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

public extension Array where Element: ParameterItem {
    func getTitles() -> [String] {
        map { $0.title }
    }
    
    func getIds() -> [Int] {
        map { $0.id }
    }
    
    func findById(_ id: Int) -> Element? {
        first { $0.id == id }
    }
    
    func findByTitle(_ title: String) -> Element? {
        first { $0.title.lowercased() == title.lowercased() }
    }
}
