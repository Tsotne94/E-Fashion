//
//  Price.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 21.01.25.
//

public struct PriceDetails: Codable {
    let amount: String
    let currency: String
    let discount: String?
    let fees: String
    let totalAmount: String
}
