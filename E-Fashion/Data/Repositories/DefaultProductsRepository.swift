//
//  DefaultProductsRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 21.01.25.
//
import Foundation
import Combine
import MyNetworkManager

public struct DefaultProductsRepository: ProductsRepository {
    public init() { }
    
    func fetchProducts(params: SearchParameters) -> AnyPublisher<[Product], Error> {
        let endpoint = APIEndpoint.search(params)
        
        return Future { promise in
            endpoint.request(
                modelType: [Product].self,
                networkManager: NetworkManager()) { result in
                    switch result {
                    case .success(let products):
                        promise(.success(products))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    func fetchSingleProduct(id: String) -> AnyPublisher<ProductDetails, Error> {
        let endpoint = APIEndpoint.getProduct(productId: id)
        
        return Future { promise in
            endpoint.request(
                modelType: ProductDetails.self,
                networkManager: NetworkManager()) { result in
                    switch result {
                    case .success(let product):
                        promise(.success(product))
                    case .failure(let error):
                        promise(.failure(error))
                        print(error.localizedDescription)
                    }
                }
        }.eraseToAnyPublisher()
    }
}
