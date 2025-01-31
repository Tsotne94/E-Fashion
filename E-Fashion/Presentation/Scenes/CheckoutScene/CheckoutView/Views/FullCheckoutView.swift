//
//  FullCheckoutView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import SwiftUI

struct FullCheckoutView: View {
    @ObservedObject var viewModel: DefaultCheckoutViewModel
    @Binding var selectedDelivery: DeliveryProviders

    var body: some View {
        VStack {
            HeaderView(viewModel: viewModel, title: "Checkout")

            ScrollView {
                AddressView(viewModel: viewModel)
                PaymentMethodView(viewModel: viewModel)
                DeliveryMethodView(selectedDelivery: $selectedDelivery)
                PriceView(viewModel: viewModel, selectedDelivery: selectedDelivery)
                OrderButton(viewModel: viewModel)
            }
        }
    }
}
