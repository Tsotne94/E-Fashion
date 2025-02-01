//
//  ProductsRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 21.01.25.
//

import Combine
import Foundation

public protocol ProductsRepository {
    func fetchProducts(params: SearchParameters) -> AnyPublisher<[Product], Error>
    func fetchSingleProduct(id: String) -> AnyPublisher<ProductDetails, Error>
    func fetchImage(for urlString: String) -> AnyPublisher<Data?, Never>
}
