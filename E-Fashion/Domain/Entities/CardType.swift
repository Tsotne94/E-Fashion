//
//  CardType.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 30.01.25.
//

enum CardType {
    case visa
    case mastercard
    case amex
    case unknown
}

func identifyCardType(cardNumber: String) -> CardType {
    guard let firstTwoDigits = Int(cardNumber.prefix(2)),
          let firstFourDigits = Int(cardNumber.prefix(4)),
          let firstDigit = cardNumber.first else {
        return .unknown
    }
    
    if firstDigit == "4" {
        return .visa
    } else if (51...55).contains(firstTwoDigits) || (2221...2720).contains(firstFourDigits) {
        return .mastercard
    } else if firstTwoDigits == 34 || firstTwoDigits == 37 {
        return .amex
    }
    
    return .unknown
}
