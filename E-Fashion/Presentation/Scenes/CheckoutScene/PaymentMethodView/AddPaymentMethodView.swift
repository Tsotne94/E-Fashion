//
//  AddPaymentMethodView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 30.01.25.
//

import SwiftUI

struct AddPaymentMethodView: View {
    let viewModel: PaymentMethodsViewModel
    
    @State private var nameOnCard: String = ""
    @State private var cardNumber: String = ""
    @State private var expireDate: String = ""
    @State private var ccv: String = ""
    @State private var isDefault: Bool = false
    
    @State private var isNameValid = false
    @State private var isCardNumberValid = false
    @State private var isExpiryValid = false
    @State private var isCCVValid = false
    
    private var isFormValid: Bool {
        isNameValid && isCardNumberValid && isExpiryValid && isCCVValid
    }
    
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
                .onChange(of: nameOnCard) { newValue in
                    nameOnCard = viewModel.formatCardPlaceholder(newValue)
                    isNameValid = viewModel.validateName(newValue)
                }
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
                    cardNumber = viewModel.formatCreditCardNumber(newValue)
                    isCardNumberValid = viewModel.validateCardNumber(newValue)
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
                    expireDate = viewModel.formatExpiryDate(newValue)
                    isExpiryValid = viewModel.validateExpiry(expireDate)
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
                    ccv = viewModel.formatCCV(newValue)
                    isCCVValid = viewModel.validateCCV(ccv)
                }
        }
    }
    
    private func addCardButton() -> some View {
        Button {
            let cardModel = CardModel(
                number: cardNumber.replacingOccurrences(of: " ", with: ""),
                holderName: nameOnCard,
                expiryDate: expireDate,
                cvv: ccv,
                isdefault: isDefault
            )
            viewModel.addPaymentMethod(cardModel)
            viewModel.dismissPresented()
        } label: {
            Text("ADD CARD")
                .font(.custom(CustomFonts.nutinoBold, size: 16))
                .foregroundColor(.white)
                .padding()
                .frame(width: 250, height: 50)
                .background(isFormValid ? Color.accentRed : Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 3)
        }
        .disabled(!isFormValid)
        .padding(.top)
    }
}
