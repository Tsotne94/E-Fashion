//
//  HeaderView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import SwiftUI

struct HeaderView: View {
    var viewModel: DefaultCheckoutViewModel
    var title: String

    var body: some View {
        HStack {
            Button {
                viewModel.goBack()
            } label: {
                Image(Icons.back)
            }
            .padding()

            SUIAuthHeaderView(title: title)
        }
        .background(.white)
    }
}
