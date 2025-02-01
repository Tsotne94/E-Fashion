//
//  RemoveFromFavourites.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 26.01.25.
//

import Combine

public protocol RemoveFromFavouritesUseCase {
    func execute(id: String) -> AnyPublisher<Void, Error>
}

public struct DefaultRemoveFromFavouritesUseCase: RemoveFromFavouritesUseCase {
    @Inject private var favouritesRepository: FirestoreFavouritesRepository
    
    public init() { }
    
    public func execute(id: String) -> AnyPublisher<Void, Error> {
        favouritesRepository.removeFromFavourites(id: id)
    }
}
