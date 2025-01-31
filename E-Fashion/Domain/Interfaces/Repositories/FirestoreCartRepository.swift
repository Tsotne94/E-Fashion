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
    func removeWholeItem(id: String) -> AnyPublisher<Void, Error>
    func isInCart(id: String) -> AnyPublisher<Bool, Error>
    func clearItems() -> AnyPublisher<Void, Error>
}
