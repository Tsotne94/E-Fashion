//
//  CheckoutView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 29.01.25.
//

import SwiftUI

struct CheckoutView: View {
    var body: some View {
        ZStack {
            HStack {
                Button {
                    print("idk")
                } label: {
                    Image(Icons.back)
                }
                .padding()

                SUIAuthHeaderView(title: "Checkout")
            }
        }
        .background(.customWhite)
    }
}

#Preview {
    CheckoutView()
}
