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
        VStack(spacing: 0) {
            Text("My Bag")
                .font(.custom(CustomFonts.nutinoBlack, size: 40))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.accentBlack)
                .padding()
            
            if viewModel.isLoading {
                SUILoader()
//                    .frame(maxHeight: .infinity)
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
                    VStack(spacing: 16) {
                        ForEach(viewModel.productsInCart, id: \.product.productId) { product in
                            ProductCardView(
                                product: product,
                                imageData: viewModel.images[product.product.images.first ?? ""],
                                onDelete: {
                                    viewModel.deleteProduct(id: product.product.productId)
                                }
                            )
                        }
                    }
                    .padding()
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
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                .background(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, y: -4)
            }
        }
        .onAppear(perform: {
            viewModel.fetchProducts()
        })
        .background(Color.customWhite)
    }
}

struct ProductCardView: View {
    let product: ProductInCart
    let imageData: Data?
    let onDelete: () -> Void
    
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
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.product.title.count > 20 ? String(product.product.title.prefix(20)) + "..." : product.product.title)
                    .font(.custom(CustomFonts.nutinoBold, size: 20))
                
                HStack {
                    Text("Color:")
                        .foregroundColor(.gray)
                    Text(product.product.color?.name ?? "N/A")
                }
                .font(.subheadline)
                
                HStack {
                    Text("Size:")
                        .foregroundColor(.gray)
                    Text(product.product.size?.name ?? "")
                }
                .font(.subheadline)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
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
                
                Text("\(product.product.price.totalAmount)$")
                    .font(.title3)
                    .fontWeight(.semibold)
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

struct BagView_Previews: PreviewProvider {
    static var previews: some View {
        BagView()
    }
}
