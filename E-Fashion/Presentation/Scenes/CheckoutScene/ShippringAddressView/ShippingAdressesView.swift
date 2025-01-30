//
//  AddShippingAdressView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 30.01.25.
//

import SwiftUI

struct ShippingAdressesView: View {
    @State private var addresses: [AddressModel] = [
        AddressModel(
            name: "John Doe",
            address: "123 Main Street",
            city: "New York",
            state: "NY",
            zip: "10001",
            country: "United States",
            isDefault: true
        ),
        AddressModel(
            name: "John Doe",
            address: "456 Park Avenue",
            city: "Los Angeles",
            state: "CA",
            zip: "90001",
            country: "United States",
            isDefault: false
        )
    ]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                SUICustomHeaderView(title: "Shipping Addresses", showBackButton: true) {
                    print("back tapped")
                }
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(addresses.indices, id: \.self) { index in
                            addressView(address: addresses[index], index: index)
                        }
                    }
                    .padding()
                }
            }
            
            Button {
                
            } label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(
                        Circle()
                            .fill(Color.black)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    )
            }
            .padding(.trailing, 20)
            .padding(.bottom, 90)
        }
        .background(Color.customWhite, ignoresSafeAreaEdges: .all)
    }
    
    private func addressView(address: AddressModel, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(address.name)
                    .font(.custom(CustomFonts.nutinoRegular, size: 16))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("Edit")
                        .font(.custom(CustomFonts.nutinoRegular, size: 15))
                        .foregroundStyle(.accentRed)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(address.address)
                    .font(.custom(CustomFonts.nutinoRegular, size: 14))
                    .foregroundColor(.primary)
                
                HStack(spacing: 4) {
                    Text(address.city)
                    Text(address.state)
                    Text(address.zip)
                    Text(address.country)
                }
                .font(.custom(CustomFonts.nutinoRegular, size: 14))
                .foregroundColor(.gray)
            }
            
            HStack(spacing: 12) {
                Button {
                    var updatedAddresses = addresses
                    updatedAddresses = updatedAddresses.map { addr in
                        var newAddr = addr
                        
                        return newAddr
                    }
                    addresses = updatedAddresses
                } label: {
                    Image(address.isDefault ? Icons.selectedBlack : Icons.selectableBox)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                
                Text("Use as default shipping address")
                    .font(.custom(CustomFonts.nutinoRegular, size: 14))
                    .foregroundColor(.primary)
                
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    ShippingAdressesView()
}
