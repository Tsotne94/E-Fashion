//
//  FetchImageUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 23.01.25.
//

import Foundation
import Combine

public protocol FetchImageUseCase {
    func execute(urlString: String) -> AnyPublisher<Data?, Never>
}

public struct DefaultFetchImageUseCase: FetchImageUseCase {
    @Inject private var productsRepository: ProductsRepository
    
    public init() { }
    
    public func execute(urlString: String) -> AnyPublisher<Data?, Never> {
        productsRepository.fetchImage(for: urlString)
    }
}
