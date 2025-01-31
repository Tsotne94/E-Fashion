//
//  EmptyStateView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import SwiftUI

struct EmptyStateView: View {
    @ObservedObject var viewModel: DefaultCheckoutViewModel

    var body: some View {
        VStack(spacing: 20) {
            HeaderView(viewModel: viewModel, title: "Checkout")

            Spacer()

            Image(systemName: "cart.badge.minus")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)

            Text("Your cart is empty")
                .font(.custom(CustomFonts.nutinoBold, size: 18))
                .foregroundColor(.gray)

            Text("Add some items to your cart before checking out")
                .font(.custom(CustomFonts.nutinoRegular, size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button {
                viewModel.goBack()
            } label: {
                Text("Continue Shopping")
                    .font(.custom(CustomFonts.nutinoBold, size: 16))
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 250, height: 50)
                    .background(Color.accentRed)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 3)
            }

            Spacer()
        }
    }
}
