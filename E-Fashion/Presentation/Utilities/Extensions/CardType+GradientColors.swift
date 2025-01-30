//
//  CardType+GradientColors.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 30.01.25.
//

import SwiftUI

extension CardType {
    func getGradientColors() -> [Color] {
        switch self {
        case .visa:
            return [
                Color(red: 0.0, green: 0.32, blue: 0.80),
                Color(red: 1.0, green: 0.84, blue: 0.0)
            ]
            
        case .mastercard:
            return [
                Color(red: 0.91, green: 0.12, blue: 0.0),
                Color(red: 1.0, green: 0.55, blue: 0.0)
            ]
            
        case .amex:
            return [
                Color(red: 0.0, green: 0.47, blue: 0.75),
                Color(red: 0.0, green: 0.32, blue: 0.61)
            ]
            
        case .unknown:
            return [
                Color(red: 0.5, green: 0.5, blue: 0.5),
                Color(red: 0.3, green: 0.3, blue: 0.3)
            ]
        }
    }
}
