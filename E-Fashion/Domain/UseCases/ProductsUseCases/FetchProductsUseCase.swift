//
//  FetchProductsUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 21.01.25.
//
import Foundation
import Combine

protocol FetchProductsUseCase {
    func execute(params: SearchParameters) -> AnyPublisher<[Product], Error>
}

struct DefaultFetchProductsUseCase: FetchProductsUseCase {
    @Inject private var productsRepository: ProductsRepository
    
    public init() {
        
    }
    
    func execute(params: SearchParameters) -> AnyPublisher<[Product], Error>{
        productsRepository.fetchProducts(params: params)
    }
}
