//
//  ProductConditions+Data.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

extension ProductCondition {
    static let allConditions: [ProductCondition] = [
        ProductCondition(id: 6, title: "New with tags",
                        description: "A brand-new, unused item with tags attached or in the original packaging."),
        ProductCondition(id: 1, title: "New without tags",
                        description: "A brand-new, unused item without tags or original packaging."),
        ProductCondition(id: 2, title: "Very good",
                        description: "A lightly used item that may have slight imperfections, but still looks great. Include photos and descriptions of any flaws in your listing."),
        ProductCondition(id: 3, title: "Good",
                        description: "A used item that may show imperfections and signs of wear. Include photos and descriptions of flaws in your listing."),
        ProductCondition(id: 4, title: "Satisfactory",
                        description: "A frequently used item with imperfections and signs of wear. Include photos and descriptions of flaws in your listing.")
    ]
}
