//
//  ProductsRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 21.01.25.
//

import Combine
import Foundation

protocol ProductsRepository {
    func fetchProducts(params: SearchParameters) -> AnyPublisher<[Product], Error>
    func fetchSingleProduct(id: String) -> AnyPublisher<Product, Error>
}
