//
//  CustomTextFieldStyle.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 18.01.25.
//
import SwiftUI

struct CustomTextFieldStyle: ViewModifier {
    let width: CGFloat
    let text: String
    let animation: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(lineWidth: 2.5)
                        .foregroundStyle(.accentRed)
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .frame(width: width, height: 27)
                            .padding(.leading, 12)
                            .foregroundStyle(.accentRed)
                        
                        Text(text)
                            .bold()
                            .padding(.leading, 20)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(y: animation)
                }
                .allowsHitTesting(false)  
            }
            .shadow(radius: 5, y: 3)
    }
}
