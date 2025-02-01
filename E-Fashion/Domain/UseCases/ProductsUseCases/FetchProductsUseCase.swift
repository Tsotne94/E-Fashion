//
//  FetchProductsUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 21.01.25.
//

import Combine

public protocol FetchProductsUseCase {
    func execute(params: SearchParameters) -> AnyPublisher<[Product], Error>
}

public struct DefaultFetchProductsUseCase: FetchProductsUseCase {
    @Inject private var productsRepository: ProductsRepository
    
    public init() {
        
    }
    
    public func execute(params: SearchParameters) -> AnyPublisher<[Product], Error>{
        productsRepository.fetchProducts(params: params)
    }
}
