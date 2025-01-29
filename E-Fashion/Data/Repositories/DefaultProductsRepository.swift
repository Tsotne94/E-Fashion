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
    @Inject private var cacheRepository: CacheRepository
    
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
    
    func fetchImage(for urlString: String) -> AnyPublisher<Data?, Never> {
        guard let url = URL(string: urlString) else {
            return Just(nil).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, _ in data }
            .map { $0.isEmpty ? nil : $0 }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
