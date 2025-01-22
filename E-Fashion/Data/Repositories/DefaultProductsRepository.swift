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
        let endpoint = APIEndpoint.shared.search(parameters: params)
        
        return Future { promise in
            APIEndpoint.shared.request(
                urlString: endpoint,
                modelType: [Product].self,
                networkManager: NetworkManager()) { result in
                    switch result {
                    case .success(let success):
                        promise(.success(success))
                    case .failure(let failure):
                        promise(.failure(failure))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    func fetchSingleProduct(id: String) -> AnyPublisher<ProductDetails, Error> {
        let endpoint = APIEndpoint.shared.getProduct(productId: id)
        
        return Future { promise in
            APIEndpoint.shared.request(
                urlString: endpoint,
                modelType: ProductDetails.self,
                networkManager: NetworkManager()) { result in
                    switch result {
                    case .success(let success):
                        promise(.success(success))
                    case .failure(let failure):
                        promise(.failure(failure))
                    }
                }
        }.eraseToAnyPublisher()
    }
}
