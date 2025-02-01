//
//  FetchFavouriteItems.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 26.01.25.
//

import Combine

public protocol FetchFavouriteItemsUseCase {
    func execute() -> AnyPublisher<[Product], Error>
}

public struct DefaultFetchFavouriteItemsUseCase: FetchFavouriteItemsUseCase {
    @Inject private var favouritesRepository: FirestoreFavouritesRepository
    
    public init() { }
    
    public func execute() -> AnyPublisher<[Product], any Error> {
        favouritesRepository.fetchFavourites()
    }
}
