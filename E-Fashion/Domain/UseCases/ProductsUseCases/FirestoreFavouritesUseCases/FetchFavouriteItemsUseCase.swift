//
//  FetchFavouriteItems.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 26.01.25.
//
import Combine

protocol FetchFavouriteItemsUseCase {
    func execute() -> AnyPublisher<[ProductDetails], Error>
}

public struct DefaultFetchFavouriteItemsUseCase: FetchFavouriteItemsUseCase {
    @Inject private var favouritesRepository: FirestoreFavouritesRepository
    
    public init() { }
    
    func execute() -> AnyPublisher<[ProductDetails], any Error> {
        favouritesRepository.fetchFavourites()
    }
}
