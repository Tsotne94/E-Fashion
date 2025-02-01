//
//  CardModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 30.01.25.
//

import Foundation

public struct CardModel: Codable {
    let id: String
    let timestamp: Date
    let number: String
    let holderName: String
    let expiryDate: String
    let cvv: String
    let isDefault: Bool
    let type: CardType
    
    public init(number: String, holderName: String, expiryDate: String, cvv: String, isdefault: Bool) {
        self.id = UUID().uuidString
        self.timestamp = Date()
        self.number = number
        self.holderName = holderName
        self.expiryDate = expiryDate
        self.cvv = cvv
        self.type = number.identifyCardType()
        self.isDefault = isdefault
    }
}
