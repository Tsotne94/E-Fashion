//
//  RemoveFromCart.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 26.01.25.
//

import Combine

protocol RemoveWholeItemFromCartUseCase {
    func execute(id: String) -> AnyPublisher<Void, Error>
}

public struct DefaultRemoveWholeItemFromCartUseCase: RemoveWholeItemFromCartUseCase {
    @Inject private var cartRepository: FirestoreCartRepository
    
    public init() { }
    
    func execute(id: String) -> AnyPublisher<Void, any Error> {
        cartRepository.removeWholeItem(id: id)
    }
}
