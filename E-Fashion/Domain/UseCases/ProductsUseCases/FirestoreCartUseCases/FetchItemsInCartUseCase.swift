//
//  FetchitemsInCart.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 26.01.25.
//

import Combine

public protocol FetchItemsInCartUseCase {
    func execute() -> AnyPublisher<[ProductInCart], Never>
}

public struct DefaultFetchItemsInCartUseCase: FetchItemsInCartUseCase {
    @Inject private var cartRepository: FirestoreCartRepository
    
    public init() { }
    
    public func execute() -> AnyPublisher<[ProductInCart], Never> {
        cartRepository.fetchItemsInCart()
    }
}
