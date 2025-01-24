//
//  Amount.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

struct PriceAmount: Codable {
    let amount: String
    let currency_code: String
    
    enum CodingKeys: String, CodingKey {
        case amount
        case currency_code
    }
}
