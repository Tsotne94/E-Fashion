//
//  ShippingAdressesView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 30.01.25.
//

import SwiftUI

struct AddShippingAddressView: View {
    @State private var fullName: String = ""
    @State private var address: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var zipCode: String = ""
    @State private var country: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            SUICustomHeaderView(title: "Adding Shipping Address", showBackButton: true) {
                print("back tapped")
            }
            
            ScrollView {
                VStack(spacing: 24) {
                    LabeledCustomTextField(
                        label: "Full Name",
                        placeholder: "Full name",
                        text: $fullName
                    )
                    
                    LabeledCustomTextField(
                        label: "Address",
                        placeholder: "Address",
                        text: $address
                    )
                    
                    LabeledCustomTextField(
                        label: "City",
                        placeholder: "City",
                        text: $city
                    )
                    
                    LabeledCustomTextField(
                        label: "State/Province/Region",
                        placeholder: "State/Province/Region",
                        text: $state
                    )
                    
                    LabeledCustomTextField(
                        label: "Zip Code (Postal Code)",
                        placeholder: "Zip Code (Postal Code)",
                        text: $zipCode,
                        keyboardType: .numberPad
                    )
                    
                    LabeledCustomTextField(
                        label: "Country",
                        placeholder: "Country",
                        text: $country
                    )
                    
                    Spacer(minLength: 32)
                    
                    Button {
                        
                    } label: {
                        Text("SAVE ADDRESS")
                            .font(.custom(CustomFonts.nutinoMedium, size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.accentRed)
                            .cornerRadius(28)
                            .shadow(color: Color.accentRed.opacity(0.3),
                                    radius: 8,
                                    x: 0,
                                    y: 4)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .padding(.bottom, 32)
            }
        }
        .background(Color.customWhite)
        .ignoresSafeArea()
    }
}

struct LabeledCustomTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.custom(CustomFonts.nutinoRegular, size: 14))
                .foregroundColor(.black)
            
            TextField(placeholder, text: $text)
                .font(.custom(CustomFonts.nutinoRegular, size: 16))
                .padding(.vertical, 16)
                .padding(.horizontal, 12)
                .background(Color.white)
                .cornerRadius(12)
                .keyboardType(keyboardType)
                .foregroundColor(.primary)
                .accentColor(.gray)
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        }
    }
}

#Preview {
    AddShippingAddressView()
}
