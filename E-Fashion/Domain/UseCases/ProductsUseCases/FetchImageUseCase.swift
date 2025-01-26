//
//  FetchImageUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 23.01.25.
//

import Foundation
import Combine

protocol FetchImageUseCase {
    func execute(urlString: String) -> AnyPublisher<Data?, Never>
}

struct DefaultFetchImageUseCase: FetchImageUseCase {
    @Inject private var productsRepository: ProductsRepository
    
    public init() { }
    
    func execute(urlString: String) -> AnyPublisher<Data?, Never> {
        productsRepository.fetchImage(for: urlString)
    }
}
