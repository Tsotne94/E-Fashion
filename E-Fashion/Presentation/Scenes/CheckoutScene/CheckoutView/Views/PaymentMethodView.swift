//
//  PaymentMethodView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import SwiftUI

struct PaymentMethodView: View {
    @ObservedObject var viewModel: DefaultCheckoutViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Payment")
                    .font(.custom(CustomFonts.nutinoBold, size: 16))
                    .shadow(radius: 3)
                Spacer()
                Button {
                    viewModel.changeCard()
                } label: {
                    Text("Change")
                        .font(.custom(CustomFonts.nutinoMedium, size: 14))
                        .foregroundStyle(.accentRed)
                }
                .padding(.trailing)
            }

            HStack {
                Image(viewModel.defaultPaymentMethod?.type.getImageName() ?? Icons.card)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(10)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text(viewModel.defaultPaymentMethod?.number.formatCardNumber().secureCardNumber() ?? "Choose Card To Continue")
                    .font(.custom(CustomFonts.nutinoRegular, size: 14))
            }
        }
        .padding()
        .onTapGesture {
            viewModel.changeCard()
        }
    }
}
