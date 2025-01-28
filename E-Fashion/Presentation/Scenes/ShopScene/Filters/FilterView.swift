//
//  FilterViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 28.01.25.
//

import SwiftUI

struct FilterView: View {
    @State private var minPrice: Double = 1
    @State private var maxPrice: Double = 500
    
    var body: some View {
        VStack {
            SUICustomHeaderView(title: "testing stuff")
            
            HStack {
                Text("$\(Int(minPrice))")
                Spacer()
                Text("$\(Int(maxPrice))")
            }
            .padding(.horizontal)
            
            SUIPriceRangeSlider(
                minPrice: $minPrice,
                maxPrice: $maxPrice,
                range: 1...500
            )
            .padding()
            
            Spacer()
        }
        .background(.customWhite)
    }
}

#Preview {
    FilterView()
}
