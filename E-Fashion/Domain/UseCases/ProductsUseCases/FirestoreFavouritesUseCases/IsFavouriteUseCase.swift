//
//  IsFavouriteUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 26.01.25.
//

import Combine

public protocol IsFavouriteUseCase {
    func execute(id: String) -> AnyPublisher<Bool, Error>
}

public struct DefaultIsFavouriteUseCase: IsFavouriteUseCase {
    @Inject private var favouritesRepository: FirestoreFavouritesRepository
    
    public init() { }
    
    public func execute(id: String) -> AnyPublisher<Bool, Error> {
        favouritesRepository.isFavourite(id: id)
    }
}
