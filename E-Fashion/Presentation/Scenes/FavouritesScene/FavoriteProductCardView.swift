//
//  FavoriteProductCardView.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import SwiftUI

struct FavoriteProductCardView: View {
    let product: Product
    let imageData: Data?
    @State var isInCart: Bool
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
                        .background(isInCart ? .customGray : Color.accentRed)
                        .clipShape(Circle())
                }
                .disabled(isInCart)
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
