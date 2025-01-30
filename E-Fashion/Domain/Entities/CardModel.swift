//
//  CardModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 30.01.25.
//

struct CardModel: Codable {
    let number: String
    let holderName: String
    let expiryDate: String
    let cvv: String
    let isDefault: Bool
    let type: CardType
    
    init(number: String, holderName: String, expiryDate: String, cvv: String, isdefault: Bool) {
        self.number = number
        self.holderName = holderName
        self.expiryDate = expiryDate
        self.cvv = cvv
        self.type = number.identifyCardType()
        self.isDefault = isdefault
    }
}
