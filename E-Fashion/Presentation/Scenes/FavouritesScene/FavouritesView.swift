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
                                imageData: viewModel.images[product.image],
                                onDelete: {
                                    viewModel.deleteProduct(id: product.productId)
                                },
                                onAddToCart: {
                                    viewModel.addToCart(id: product.productId)
                                }
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel.fetchProducts()
        }
        .background(Color.customWhite)
    }
}

struct FavoriteProductCardView: View {
    let product: Product
    let imageData: Data?
    let onDelete: () -> Void
    let onAddToCart: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 120)
                    .clipped()
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 100, height: 120)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.brand ?? "N/A")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(product.title.count > 20 ? String(product.title.prefix(20)) + "..." : product.title)
                    .font(.custom(CustomFonts.nutinoBold, size: 20))
                
                HStack {
                    Text("Size:")
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
                    Text(product.size ?? "")
                }
                .font(.subheadline)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 12) {
                Menu {
                    Button(role: .destructive, action: onDelete) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                        .padding(8)
                }
                
                Spacer()
                
                Text("\(product.price.totalAmount.amount)$")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Button(action: onAddToCart) {
                    Image(systemName: "bag")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.accentRed)
                        .clipShape(Circle())
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8)
        )
    }
}
