//
//  PaymentMethodsView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 30.01.25.
//

import SwiftUI

struct PaymentMethodsView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 0) {
                SUICustomHeaderView(title: "Payment Methods", showBackButton: true) {
                    print("back tapped")
                }
                
                Text("Your Payment Methods")
                    .font(.custom(CustomFonts.nutinoMedium, size: 18))
                    .padding(.horizontal)
                    .padding(.top, 16)
                
                ScrollView {
                    cardSection(card: CardModel(
                        number: "5155 5678 9012 3456",
                        holderName: "John Doe",
                        expiryDate: "12/28",
                        cvv: "123",
                        isdefault: true))
                    .padding()
                }
                
                Spacer()
            }
            
            Button {
                print("Add payment method tapped")
            } label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(
                        Circle()
                            .fill(Color.black)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    )
            }
            .padding(.trailing, 20)
            .padding(.bottom, 20)
        }
        .background(Color.customWhite)
        .ignoresSafeArea()
    }
    
    private func cardSection(card: CardModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            cardView(card: card)
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
            
            HStack(spacing: 12) {
                Button {
                    print("selected as primary")
                } label: {
                    Image(card.isDefault ? Icons.selectedBlack : Icons.selectableBox)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                
                Text("Use as default payment method")
                    .font(.custom(CustomFonts.nutinoRegular, size: 16))
                    .foregroundColor(.primary)
            }
        }
    }
    
    private func cardView(card: CardModel) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(Icons.chip)
                    .resizable()
                    .frame(width: 45, height: 35)
                
                Spacer()
                
                Image(card.number.identifyCardType().getImageName())
                    .resizable()
                    .frame(width: 60, height: 40)
                    .aspectRatio(contentMode: .fit)
            }
            
            Text(card.number.formatCardNumber().secureCardNumber())
                .font(.custom(CustomFonts.nutinoRegular, size: 22))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Card Holder Name")
                        .font(.custom(CustomFonts.nutinoRegular, size: 12))
                        .foregroundColor(Color.white.opacity(0.8))
                    Text(card.holderName)
                        .font(.custom(CustomFonts.nutinoMedium, size: 16))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Expiry")
                        .font(.custom(CustomFonts.nutinoRegular, size: 12))
                        .foregroundColor(Color.white.opacity(0.8))
                    Text(card.expiryDate)
                        .font(.custom(CustomFonts.nutinoMedium, size: 16))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                }
            }
        }
        .padding(24)
        .background(
            ZStack {
                LinearGradient(
                    colors: card.type.getGradientColors(),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                Color.white
                    .opacity(0.05)
                    .blendMode(.plusLighter)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    PaymentMethodsView()
}
