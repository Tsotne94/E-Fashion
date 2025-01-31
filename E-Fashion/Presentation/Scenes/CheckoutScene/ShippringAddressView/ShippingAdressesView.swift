//
//  AddShippingAdressView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 30.01.25.
//

import SwiftUI
import Combine

struct ShippingAdressesView: View {
    @Inject private var coordinator: BagTabCoordinator
    @StateObject private var viewModel = DefaultShippingAddressesViewModel()
    
    @State private var cancellables = Set<AnyCancellable>()
    @State private var showDefaultAddressAlert = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 0) {
                SUICustomHeaderView(title: "Shipping Addresses", showBackButton: true) {
                    coordinator.goBack()
                }
                
                if viewModel.addresses.isEmpty {
                    emptyStateView()
                } else {
                    Text("Your Shipping Addresses")
                        .font(.custom(CustomFonts.nutinoMedium, size: 18))
                        .padding(.horizontal)
                        .padding(.top, 16)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.addresses.indices, id: \.self) { index in
                                addressView(address: viewModel.addresses[index], index: index)
                            }
                        }
                        .padding()
                    }
                }
                Spacer()
            }
            
            Button {
                coordinator.addDeliveryLoaction(viewmodel: viewModel)
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
        .background(Color.customWhite)
        .ignoresSafeArea()
        .alert(isPresented: $showDefaultAddressAlert) {
            Alert(
                title: Text("Default Address"),
                message: Text("This is already your default shipping address. To change, select another address or delete this one."),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            viewModel.fetchAddresses()
        }
    }
    
    private func emptyStateView() -> some View {
        VStack(spacing: 20) {
            Image(systemName: "map")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray.opacity(0.5))
            
            Text("No Shipping Addresses")
                .font(.custom(CustomFonts.nutinoMedium, size: 20))
                .foregroundColor(.primary)
            
            Text("Add your first shipping address to start managing your delivery locations.")
                .font(.custom(CustomFonts.nutinoRegular, size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    private func updateDefaultAddress(_ newDefaultAddress: AddressModel) {
        if !newDefaultAddress.isDefault {
            viewModel.setDefaultAddress(newDefaultAddress)
        }
    }
    
    private func addressView(address: AddressModel, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(address.name)
                    .font(.custom(CustomFonts.nutinoRegular, size: 16))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button {
                    viewModel.removeAddress(address)
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
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
                    if address.isDefault {
                        showDefaultAddressAlert = true
                    } else {
                        viewModel.setDefaultAddress(address)
                    }
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
