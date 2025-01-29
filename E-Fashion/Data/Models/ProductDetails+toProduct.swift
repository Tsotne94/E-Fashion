//
//  ProductDetails+toProduct.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 27.01.25.
//

extension ProductDetails {
    func toProduct() -> Product {
        return Product(
            productId: self.productId,
            title: self.title,
            url: self.url,
            image: self.images.first ?? "",
            promoted: self.promoted,
            favourites: self.favourites,
            brand: self.brand.name,
            size: self.size?.name,
            price: Price(
                amount: PriceAmount(
                    amount: self.price.amount,
                    currency_code: self.price.currency
                ),
                currency: self.price.currency,
                discount: self.price.discount,
                fees: PriceAmount(
                    amount: self.price.fees,
                    currency_code: self.price.currency
                ),
                totalAmount: PriceAmount(
                    amount: self.price.totalAmount,
                    currency_code: self.price.currency
                )
            ),
            seller: Seller(
                userId: self.seller.userId,
                username: self.seller.username,
                profile: self.seller.url,
                profilePicture: self.seller.image
            )
        )
    }
}
