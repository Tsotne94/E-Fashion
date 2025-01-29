//
//  FirestoreCartRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 26.01.25.
//

import Combine

protocol FirestoreCartRepository {
    func addToCart(product: ProductInCart) -> AnyPublisher<Void, Error>
    func fetchItemsInCart() -> AnyPublisher<[ProductInCart], Never>
    func removeOneItemFromCart(id: String) -> AnyPublisher<Void, Error>
    func removeWholeItem(id: String) -> AnyPublisher<Void, Error>
}
