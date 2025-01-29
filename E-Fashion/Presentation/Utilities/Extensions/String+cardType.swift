//
//  String+cardType.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 30.01.25.
//

extension String {
    func identifyCardType() -> CardType {
        guard let firstTwoDigits = Int(self.prefix(2)),
              let firstFourDigits = Int(self.prefix(4)),
              let firstDigit = self.first else {
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
}
