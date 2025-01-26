//
//  FirestoreFavouritesRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 26.01.25.
//
import Combine

protocol FirestoreFavouritesRepository {
    func addItemToFavourites(product: ProductDetails) -> AnyPublisher<Void, Error>
    func fetchFavourites() -> AnyPublisher<[ProductDetails], Error>
    func removeFromFavourites(id: String) -> AnyPublisher<Void, Never>
}
