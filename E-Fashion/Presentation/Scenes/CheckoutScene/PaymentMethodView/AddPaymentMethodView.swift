//
//  AddPaymentMethodView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 30.01.25.
//

import SwiftUI

struct AddPaymentMethodView: View {
    @State private var nameOnCard: String = ""
    @State private var cardNumber: String = ""
    @State private var expireDate: String = ""
    @State private var ccv: String = ""
    @State private var isDefault: Bool = true
    @State private var areFieldsValid: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            nameOnCardTextField()
            cardNumberTextField()
            
            HStack(spacing: 16) {
                expireDateTextField()
                ccvTextField()
            }
            addCardButton()
        }
        .padding()
    }

    private func nameOnCardTextField() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Name on Card")
                .font(.custom(CustomFonts.nutinoRegular, size: 14))
                .foregroundColor(.gray)
            
            TextField("Enter cardholder name", text: $nameOnCard)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.words)
        }
    }
    
    private func cardNumberTextField() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Card Number")
                .font(.custom(CustomFonts.nutinoRegular, size: 14))
                .foregroundColor(.gray)
            
            TextField("Enter card number", text: $cardNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .onChange(of: cardNumber) { newValue in
                    cardNumber = formatCardNumber(newValue)
                }
        }
    }
    
    private func expireDateTextField() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Expiry Date")
                .font(.custom(CustomFonts.nutinoRegular, size: 14))
                .foregroundColor(.gray)
            
            TextField("MM/YY", text: $expireDate)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .onChange(of: expireDate) { newValue in
                    expireDate = formatExpiryDate(newValue)
                }
                .onChange(of: expireDate) { newValue in
                    if newValue.count > 5 {
                        expireDate = String(newValue.prefix(5))
                    }
                }
        }
    }
    
    private func ccvTextField() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("CCV")
                .font(.custom(CustomFonts.nutinoRegular, size: 14))
                .foregroundColor(.gray)
            
            TextField("Enter CCV", text: $ccv)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .onChange(of: ccv) { newValue in
                    if newValue.count > 4 {
                        ccv = String(newValue.prefix(4))
                    }
                }
        }
    }
    
    private func formatCardNumber(_ number: String) -> String {
        let cleaned = number.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var formatted = ""
        for (index, char) in cleaned.enumerated() {
            if index > 0 && index % 4 == 0 {
                formatted += " "
            }
            formatted.append(char)
        }
        return String(formatted.prefix(19)) 
    }
    
    private func formatExpiryDate(_ date: String) -> String {
        let cleaned = date.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        if cleaned.count > 2 {
            let month = String(cleaned.prefix(2))
            let year = String(cleaned.suffix(from: cleaned.index(cleaned.startIndex, offsetBy: 2)))
            return "\(month)/\(year)"
        }
        return cleaned
    }
    
    private func addCardButton() -> some View {
        Button {
            
        } label: {
            Text("ADD CARD")
                .font(.custom(CustomFonts.nutinoBold, size: 16))
                .foregroundColor(.white)
                .padding()
                .frame(width: 250, height: 50)
                .background(Color.accentRed)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 3)
        }
        .padding(.top)
    }
}

#Preview {
    AddPaymentMethodView()
}
