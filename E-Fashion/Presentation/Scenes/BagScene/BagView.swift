//
//  BagViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 14.01.25.
//

import SwiftUI

struct BagView: View {
    @StateObject private var viewModel = DefaultBagViewModel()
    
    var body: some View {
        VStack() {
            SUIAuthHeaderView(title: "MyBag")
            
            if viewModel.isLoading {
                SUILoader()
            } else if viewModel.productsInCart.isEmpty {
                VStack(spacing: 16) {
                    Image(Icons.cartBadge)
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    
                    Text("Your bag is empty")
                        .font(.custom(CustomFonts.nutinoBold, size: 20))
                        .foregroundColor(.gray)
                }
                .frame(maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.productsInCart, id: \.product.productId) { product in
                            ProductCardView(
                                product: product,
                                imageData: viewModel.images[product.product.images.first ?? ""],
                                onDelete: {
                                    viewModel.deleteProduct(id: product.product.productId)
                                }
                            )
                            .onTapGesture {
                                if let id = Int(product.id) {
                                    viewModel.goToProductDetail(id: id)
                                }
                            }
                        }
                    }
                    .padding(.top, 5)
                    .padding(.horizontal)
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    HStack {
                        Text("Total amount:")
                            .foregroundColor(.customGray)
                        Spacer()
                        Text("\(viewModel.totalPrice ?? 0, specifier: "%.2f")$")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        viewModel.goToCheckout()
                    }) {
                        Text("CHECK OUT")
                            .font(.custom(CustomFonts.nutinoBold, size: 20))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(.accentRed)
                            .cornerRadius(25)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                .background(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, y: -4)
            }
        }
        .background(ignoresSafeAreaEdges: .all)
        .onAppear(perform: {
            viewModel.fetchProducts()
        })
        .background(Color.customWhite)
    }
}
