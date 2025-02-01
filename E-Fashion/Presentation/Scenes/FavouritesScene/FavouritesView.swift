//
//  FavouritesViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 14.01.25.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = DefaultFavouritesViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            SUIAuthHeaderView(title: "Favourites")
                .padding(.horizontal)
            if viewModel.isLoading {
                SUILoader()
            } else if viewModel.favouriteProducts.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    
                    Text("Your favorites list is empty")
                        .font(.custom(CustomFonts.nutinoBold, size: 20))
                        .foregroundColor(.gray)
                }
                .frame(maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.favouriteProducts, id: \.productId) { product in
                            FavoriteProductCardView(
                                product: product,
                                imageData: viewModel.images[product.image], isInCart: viewModel.isInCart[product.productId] ?? false,
                                onDelete: {
                                    viewModel.deleteProduct(id: product.productId)
                                },
                                onAddToCart: {
                                    viewModel.addToCart(id: product.productId)
                                }
                            )
                            .onTapGesture {
                                viewModel.goToProductDetail(id: product.productId)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel.fetchProducts()
            viewModel.fetchItemsinCart()
        }
        .background(Color.customWhite)
    }
}
