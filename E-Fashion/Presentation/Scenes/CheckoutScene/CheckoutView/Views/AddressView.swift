//
//  AddressView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var viewModel: DefaultCheckoutViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Shipping Address")
                .font(.custom(CustomFonts.nutinoBold, size: 16))
                .shadow(radius: 3)

            VStack(alignment: .leading) {
                HStack {
                    Text(viewModel.defaultDeliveryLocation?.name ?? "N/A")
                        .font(.custom(CustomFonts.nutinoMedium, size: 14))
                    Spacer()
                    Button {
                        viewModel.changeDeliveryLocation()
                    } label: {
                        Text("Change")
                            .font(.custom(CustomFonts.nutinoMedium, size: 14))
                            .foregroundStyle(.accentRed)
                    }
                }
                .padding(.bottom, 16)

                Text(viewModel.defaultDeliveryLocation?.city ?? "")
                    .font(.custom(CustomFonts.nutinoMedium, size: 16))

                HStack(spacing: 4) {
                    Text(viewModel.defaultDeliveryLocation?.address ?? "Choose Address To Continue")
                        .font(.custom(CustomFonts.nutinoRegular, size: 14))
                    Text(viewModel.defaultDeliveryLocation?.zip ?? "")
                        .font(.custom(CustomFonts.nutinoRegular, size: 14))
                    Text(viewModel.defaultDeliveryLocation?.country ?? "")
                        .font(.custom(CustomFonts.nutinoRegular, size: 14))
                }
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding()
        .onTapGesture {
            viewModel.changeDeliveryLocation()
        }
    }
}
