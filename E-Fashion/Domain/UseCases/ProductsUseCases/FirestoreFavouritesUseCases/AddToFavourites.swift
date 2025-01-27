//
//  AddToFavourites.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 26.01.25.
//

import Combine

protocol AddToFavouritesUseCase {
    func execute(product: Product) -> AnyPublisher<Void, Error>
}

public struct DefaultAddToFavouritesUseCase: AddToFavouritesUseCase {
    @Inject private var favouritesRepository: FirestoreFavouritesRepository
    
    public init() { }
    
    func execute(product: Product) -> AnyPublisher<Void, any Error> {
        favouritesRepository.addItemToFavourites(product: product)
    }
}
