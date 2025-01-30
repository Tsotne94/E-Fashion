//
//  ProductCardView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import SwiftUI

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
