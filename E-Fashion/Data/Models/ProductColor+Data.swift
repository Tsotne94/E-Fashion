//
//  ProductColor+Data.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

extension ProductColor: Hashable {
    static let allColors: [ProductColor] = [
        ProductColor(id: 9, title: "Blue"),
        ProductColor(id: 27, title: "Navy"),
        ProductColor(id: 26, title: "Light blue"),
        ProductColor(id: 1, title: "Black"),
        ProductColor(id: 3, title: "Gray"),
        ProductColor(id: 12, title: "White"),
        ProductColor(id: 15, title: "Multi"),
        ProductColor(id: 16, title: "Khaki"),
        ProductColor(id: 23, title: "Burgundy"),
        ProductColor(id: 28, title: "Dark green"),
        ProductColor(id: 29, title: "Mustard"),
        ProductColor(id: 30, title: "Mint"),
        ProductColor(id: 8, title: "Yellow")
    ]
    
    static func == (lhs: ProductColor, rhs: ProductColor) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
