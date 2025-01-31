//
//  CheckoutView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 29.01.25.
//

import SwiftUI

struct CheckoutView: View {
    @Inject private var coordinator: BagTabCoordinator
    
    var body: some View {
        VStack {
            header()
            ScrollView {
                address()
                    .shadow(radius: 5)
                paymentMethod()
                deliveryMethod()
                price()
                orderButton()
            }
        }
        .background(.customWhite)
        .background(ignoresSafeAreaEdges: .all)
    }
    
    private func header() -> some View {
        HStack {
            Button {
                coordinator.goBack()
            } label: {
                Image(Icons.back)
            }
            .padding()
            
            SUIAuthHeaderView(title: "Checkout")
        }
        .background(.white)
    }
    
    private func address() -> some View {
        VStack(alignment: .leading) {
            Text("Shipping Adress")
                .font(.custom(CustomFonts.nutinoBold, size: 16))
                .shadow(radius: 3)
            VStack(alignment: .leading) {
                HStack {
                    Text("Jhon Doe")
                        .font(.custom(CustomFonts.nutinoMedium, size: 14))
                    Spacer()
                    Button {
                        coordinator.changeDeliveryLocation()
                    } label: {
                        Text("Change")
                            .font(.custom(CustomFonts.nutinoMedium, size: 14))
                            .foregroundStyle(.accentRed)
                    }
                }
                .padding(.bottom, 16)
                Text("3 Newbridge Court Chino Hills, CA 91709, United States")
                    .font(.custom(CustomFonts.nutinoRegular, size: 14))
                    .frame(maxWidth: 200)
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding()
    }
    
    private func paymentMethod() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Payment")
                    .font(.custom(CustomFonts.nutinoBold, size: 16))
                    .shadow(radius: 3)
                Spacer()
                Button {
                    coordinator.changeCard()
                } label: {
                    Text("Change")
                        .font(.custom(CustomFonts.nutinoMedium, size: 14))
                        .foregroundStyle(.accentRed)
                }
            }
            
            HStack {
                Image(Icons.masterCard)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(10)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("**** **** **** 3947")
                    .font(.custom(CustomFonts.nutinoRegular, size: 14))
            }
        }
        .padding()
    }
    
    private func deliveryMethod() -> some View {
        VStack {
            HStack(spacing: 10) {
                deliveryProvider(provider: .dhl)
                    .shadow(radius: 5)
                deliveryProvider(provider: .fedex)
                    .shadow(radius: 5)
                deliveryProvider(provider: .usps)
                    .shadow(radius: 5)
            }
        }
        .padding()
    }
    
    private func deliveryProvider(provider: DeliveryProviders) -> some View {
        ZStack {
            VStack {
                Image(provider.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                    .padding(.horizontal, 10)
                switch provider {
                case .dhl:
                    Text("2-3 Day")
                        .font(.custom(CustomFonts.nutinoLight, size: 11))
                        .foregroundStyle(.customGray)
                case .usps:
                    Text("3-4 Day")
                        .font(.custom(CustomFonts.nutinoLight, size: 11))
                        .foregroundStyle(.customGray)
                case .fedex:
                    Text("4-5 Day")
                        .font(.custom(CustomFonts.nutinoLight, size: 11))
                        .foregroundStyle(.customGray)
                }
            }
            .padding(10)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    private func price() -> some View {
        VStack(spacing: 8) {
            HStack {
                Text("Order:")
                    .font(.custom(CustomFonts.nutinoMedium, size: 14))
                    .foregroundStyle(.customGray)
                Spacer()
                Text("112$")
                    .font(.custom(CustomFonts.nutinoBold, size: 16))
            }
            
            HStack {
                Text("Delivery:")
                    .font(.custom(CustomFonts.nutinoMedium, size: 14))
                    .foregroundStyle(.customGray)
                Spacer()
                Text("15$")
                    .font(.custom(CustomFonts.nutinoBold, size: 16))
            }
            
            HStack {
                Text("Summary:")
                    .font(.custom(CustomFonts.nutinoBold, size: 16))
                    .foregroundStyle(.customGray)
                Spacer()
                Text("127$")
                    .font(.custom(CustomFonts.nutinoBold, size: 18))
            }
        }
        .padding()
    }
    
    private func orderButton() -> some View {
        Button {
            coordinator.orderPlaced()
        } label: {
            Text("SUBMIT ORDER")
                .font(.custom(CustomFonts.nutinoBold, size: 16))
                .foregroundColor(.white)
                .padding()
                .frame(width: 250, height: 50)
                .background(Color.accentRed)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 3)
        }
    }
}

#Preview {
    CheckoutView()
}
