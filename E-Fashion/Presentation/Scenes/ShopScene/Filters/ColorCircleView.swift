//
//  ColorCircleView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 28.01.25.
//

import SwiftUI

struct ColorCircleView: View {
    let color: Color
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: 40, height: 40)
                .shadow(radius: 2)
            
            if isSelected {
                Circle()
                    .strokeBorder(Color.blue, lineWidth: 2)
                    .frame(width: 46, height: 46)
            }
        }
    }
}
