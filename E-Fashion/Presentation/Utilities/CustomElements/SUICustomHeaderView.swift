//
//  SUICustomHeaderView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 28.01.25.
//

import SwiftUI

struct SUICustomHeaderView: View {
    var title: String
    var showBackButton: Bool = true
    var backButtonTapped: (() -> Void)? = nil
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Color.white
            
            Text(title)
                .font(.custom(CustomFonts.nutinoBold, size: 18))
                .foregroundColor(.accentBlack)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 15)
            
            if showBackButton {
                Button(action: {
                    backButtonTapped?()
                }) {
                    Image(Icons.back)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
                .padding(.leading, 15)
                .padding(.bottom, 15)
            }
        }
        .frame(height: CustomHeaderView.headerHeight())
        .clipped()
    }
}
