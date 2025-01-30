//
//  CardType+Images.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 30.01.25.
//

extension CardType {
    func getImageName() -> String {
        switch self {
        case .visa:
            return Icons.visa
        case .mastercard:
            return Icons.masterCard
        case .amex:
            return Icons.amex
        case .unknown:
            return Icons.card
        }
    }
}
