//
//  AddToCart.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 26.01.25.
//

import Combine

public protocol AddToCartUseCase {
    func execute(product: ProductInCart) -> AnyPublisher<Void, Error>
}

public struct DefaultAddToCartUseCase: AddToCartUseCase {
    @Inject private var cartRepository: FirestoreCartRepository
    
    public init() { }
    
    public func execute(product: ProductInCart) -> AnyPublisher<Void, any Error> {
        cartRepository.addToCart(product: product)
    }
}
