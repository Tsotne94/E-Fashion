//
//  CardModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 30.01.25.
//

struct CardModel {
    let number: String
    let holderName: String
    let expiryDate: String
    let cvv: String
    let type: CardType
    
    init(number: String, holderName: String, expiryDate: String, cvv: String) {
        self.number = number
        self.holderName = holderName
        self.expiryDate = expiryDate
        self.cvv = cvv
        self.type = number.identifyCardType()
    }
}
