//
//  Price.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

public struct Price: Codable {
    let amount: PriceAmount
    let currency: String?
    let discount: String?
    let fees: PriceAmount
    let totalAmount: PriceAmount
}
