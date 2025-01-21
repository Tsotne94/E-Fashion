//
//  FetchSingleProductUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 21.01.25.
//

import Foundation
import Combine

protocol FetchSingleProductUseCase {
    func execute(id: String) -> AnyPublisher<ProductDetails, Error>
}

struct DefaultFetchSingleProductUseCase: FetchSingleProductUseCase {
    @Inject private var productsRepository: ProductsRepository

    public init() { }
    
    func execute(id: String) -> AnyPublisher<ProductDetails, any Error> {
        productsRepository.fetchSingleProduct(id: id)
    }
}
