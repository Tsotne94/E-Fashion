//
//  IsInCartUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 27.01.25.
//

import Combine

public protocol IsInCartUseCase {
    func execute(id: String) -> AnyPublisher<Bool, Error>
}

public struct DefaultIsInCartUseCase: IsInCartUseCase {
    @Inject private var firestoreCartRepository: FirestoreCartRepository
    
    public init() { }
    
    public func execute(id: String) -> AnyPublisher<Bool, any Error> {
        firestoreCartRepository.isInCart(id: id)
    }
}
