//
//  FetchSingleProductUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 21.01.25.
//

import Foundation
import Combine

protocol FetchSingleProductUseCase {
    func execute(id: String) -> AnyPublisher<Product, Error>
}

struct DefaultFetchSingleProductUseCase: FetchSingleProductUseCase {
    @Inject private var productsRepository: ProductsRepository

    public init() { }
    
    func execute(id: String) -> AnyPublisher<Product, any Error> {
        productsRepository.fetchSingleProduct(id: id)
    }
}
