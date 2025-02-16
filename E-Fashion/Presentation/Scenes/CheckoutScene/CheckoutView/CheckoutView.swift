//
//  CheckoutView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 29.01.25.
//

import SwiftUI

struct CheckoutView: View {
    @StateObject private var viewModel = DefaultCheckoutViewModel()
    
    var body: some View {
        VStack {
            if viewModel.products.isEmpty {
                EmptyStateView(viewModel: viewModel)
            } else {
                FullCheckoutView(viewModel: viewModel, selectedDelivery: $viewModel.selectedDelivery)
            }
        }
        .onAppear {
            viewModel.fetchProducts()
            viewModel.fetchDefaultAddress()
            viewModel.fetchDefaultPayment()
        }
        .background(.customWhite)
        .background(ignoresSafeAreaEdges: .all)
    }
}

struct DeliveryMethodView: View {
    @Binding var selectedDelivery: DeliveryProviders
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                ForEach(DeliveryProviders.allCases, id: \ .self) { provider in
                    DeliveryProviderView(provider: provider, selectedDelivery: $selectedDelivery)
                }
            }
        }
        .padding()
    }
}

struct DeliveryProviderView: View {
    let provider: DeliveryProviders
    @Binding var selectedDelivery: DeliveryProviders
    
    var body: some View {
        ZStack {
            VStack {
                Image(provider.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                    .padding(.horizontal, 10)
                Text(provider.deliveryTime())
                    .font(.custom(CustomFonts.nutinoLight, size: 11))
                    .foregroundStyle(.customGray)
            }
            .padding(10)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .onTapGesture {
                selectedDelivery = provider
            }
        }
    }
}

struct PriceView: View {
    @ObservedObject var viewModel: DefaultCheckoutViewModel
    var selectedDelivery: DeliveryProviders
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Order:")
                    .font(.custom(CustomFonts.nutinoMedium, size: 14))
                    .foregroundStyle(.customGray)
                Spacer()
                Text(price(viewModel.totalPrice ?? 0.0) + "$")
                    .font(.custom(CustomFonts.nutinoBold, size: 16))
            }
            
            HStack {
                Text("Delivery:")
                    .font(.custom(CustomFonts.nutinoMedium, size: 14))
                    .foregroundStyle(.customGray)
                Spacer()
                Text(price(selectedDelivery.price()) + "$")
                    .font(.custom(CustomFonts.nutinoBold, size: 16))
            }
            
            HStack {
                Text("Summary:")
                    .font(.custom(CustomFonts.nutinoBold, size: 16))
                    .foregroundStyle(.customGray)
                Spacer()
                Text(price((viewModel.totalPrice ?? 0.0) + selectedDelivery.price()) + "$")
                    .font(.custom(CustomFonts.nutinoBold, size: 18))
            }
        }
        .padding()
    }
    
    func price(_ price: Double) -> String {
        if viewModel.totalPrice == nil {
            return "0.00"
        }
        return String(format: "%.2f", price)
    }
}

struct OrderButton: View {
    @ObservedObject var viewModel: DefaultCheckoutViewModel
    
    var body: some View {
        Button {
            viewModel.orderPlaced()
        } label: {
            Text("SUBMIT ORDER")
                .font(.custom(CustomFonts.nutinoBold, size: 16))
                .foregroundColor(.white)
                .padding()
                .frame(width: 250, height: 50)
                .background(viewModel.isVlaid() ? .customGray : Color.accentRed )
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 3)
        }
        .disabled(viewModel.isVlaid())
    }
}
