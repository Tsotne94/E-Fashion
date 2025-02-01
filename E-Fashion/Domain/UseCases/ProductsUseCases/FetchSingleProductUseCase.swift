//
//  FetchSingleProductUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 21.01.25.
//

import Combine

public protocol FetchSingleProductUseCase {
    func execute(id: String) -> AnyPublisher<ProductDetails, Error>
}

public struct DefaultFetchSingleProductUseCase: FetchSingleProductUseCase {
    @Inject private var productsRepository: ProductsRepository

    public init() { }
    
    public func execute(id: String) -> AnyPublisher<ProductDetails, any Error> {
        productsRepository.fetchSingleProduct(id: id)
    }
}
