//
//  FirestoreFavouritesRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 26.01.25.
//

import Combine

protocol FirestoreFavouritesRepository {
    func addItemToFavourites(product: Product) -> AnyPublisher<Void, Error>
    func fetchFavourites() -> AnyPublisher<[Product], Error>
    func removeFromFavourites(id: String) -> AnyPublisher<Void, Error>
    func isFavourite(id: String) -> AnyPublisher<Bool, Error>
}
