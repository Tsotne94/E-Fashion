//
//  PaymentMethodsView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 30.01.25.
//

import SwiftUI
import Combine

struct PaymentMethodsView: View {
    @Inject private var coordinator: BagTabCoordinator
    @StateObject private var viewModel = DefaultPaymentMethodsViewModel()
    
    @State private var cancellables = Set<AnyCancellable>()
    @State private var showDefaultMethodAlert = false
    let goBack: () -> ()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 0) {
                SUICustomHeaderView(title: "Payment Methods", showBackButton: true) {
                    goBack()
                }
                
                if viewModel.paymentMethods.isEmpty {
                    emptyStateView()
                } else {
                    Text("Your Payment Methods")
                        .font(.custom(CustomFonts.nutinoMedium, size: 18))
                        .padding(.horizontal)
                        .padding(.top, 16)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.paymentMethods.indices, id: \.self) { index in
                                paymentMethodView(method: viewModel.paymentMethods[index], index: index)
                            }
                        }
                        .padding()
                    }
                }
                Spacer()
            }
            
            Button {
                coordinator.addCard(viewModel: viewModel)
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
            .padding(.bottom, 90)
        }
        .background(Color.customWhite)
        .ignoresSafeArea()
        .alert(isPresented: $showDefaultMethodAlert) {
            Alert(
                title: Text("Default Payment Method"),
                message: Text("This is already your default payment method. To change, select another method or delete this one."),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            viewModel.fetchPaymentMethods()
        }
    }
    
    private func emptyStateView() -> some View {
        VStack(spacing: 20) {
            Image(systemName: "creditcard")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray.opacity(0.5))
            
            Text("No Payment Methods")
                .font(.custom(CustomFonts.nutinoMedium, size: 20))
                .foregroundColor(.primary)
            
            Text("Add your first payment method to start managing your cards.")
                .font(.custom(CustomFonts.nutinoRegular, size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    private func paymentMethodView(method: CardModel, index: Int) -> some View {
        VStack(alignment: .trailing, spacing: 16) {
            Button {
                viewModel.removePaymentMethod(method)
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            cardSection(card: method)
        }
    }
    
    private func cardSection(card: CardModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            cardView(card: card)
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
            
            HStack(spacing: 12) {
                Button {
                    if card.isDefault {
                        showDefaultMethodAlert = true
                    } else {
                        viewModel.setDefaultPaymentMethod(card)
                    }
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
