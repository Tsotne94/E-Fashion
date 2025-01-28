//
//  ConditionButtonView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 28.01.25.
//
import SwiftUI

struct ConditionButtonView: View {
    let title: String
    let description: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(Font.custom(CustomFonts.nutinoBold, size: 16))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? .accentRed : Color.white)
            .foregroundColor(isSelected ? .white : .black)
            .overlay(
                Capsule()
                    .strokeBorder(isSelected ? .accentBlack : Color.gray.opacity(0.5), lineWidth: 1)
            )
            .clipShape(Capsule())
    }
}
