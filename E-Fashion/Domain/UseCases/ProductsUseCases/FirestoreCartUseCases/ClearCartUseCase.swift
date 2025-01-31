//
//  ClearCartUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import Combine

protocol ClearCartUseCase {
    func execute() -> AnyPublisher<Void, Error>
}

public struct DefaultClearCartUseCase: ClearCartUseCase {
    @Inject private var cartRepository: FirestoreCartRepository
    
    func execute() -> AnyPublisher<Void, Error> {
        cartRepository.clearItems()
    }
}
