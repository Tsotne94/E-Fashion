//
//  RemoveFromFavourites.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 26.01.25.
//
import Combine

protocol RemoveFromFavouritesUseCase {
    func execute(id: String) -> AnyPublisher<Void, Never>
}

public struct DefaultRemoveFromFavouritesUseCase: RemoveFromFavouritesUseCase {
    @Inject private var favouritesRepository: FirestoreFavouritesRepository
    
    public init() { }
    
    func execute(id: String) -> AnyPublisher<Void, Never> {
        favouritesRepository.removeFromFavourites(id: id)
    }
}
