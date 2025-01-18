//
//  File.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 18.01.25.
//
import SwiftUI

extension View {
    func textFieldStyle(width: CGFloat, text: String, animation: CGFloat) -> some View {
        modifier(CustomTextFieldStyle(width: width, text: text, animation: animation))
    }
}
