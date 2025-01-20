//
//  Price.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

struct Price: Codable {
    let amount: Amount
    let currency: String?
    let discount: Int?
    let fees: Fees
    let totalAmount: Amount
}
