//
//  RemoveOneFromCart.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 26.01.25.
//
import Combine

protocol RemoveOneFromCartUseCase {
    func execute(id: String) -> AnyPublisher<Void, Error>
}

public struct DefaultRemoveOneFromCartUseCase: RemoveOneFromCartUseCase {
    @Inject private var cartRepository: FirestoreCartRepository
    
    public init() { }
    
    func execute(id: String) -> AnyPublisher<Void, any Error> {
        cartRepository.removeOneItemFromCart(id: id)
    }
}
