//
//  APIEndpoint.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.

import MyNetworkManager
import Foundation

enum APIEndpoint {
    case search(SearchParameters)
    case getProduct(productId: String, country: String = "us")
    
    private var baseURL: String {
        return "https://vinted3.p.rapidapi.com"
    }
    
    var urlString: String {
        switch self {
        case .search(let parameters):
            var components = URLComponents(string: baseURL + "/getSearch")!
            components.queryItems = parameters.toQueryItems()
            return components.url?.absoluteString ?? ""
            
        case .getProduct(let productId, let country):
            var components = URLComponents(string: baseURL + "/getProduct")!
            components.queryItems = [
                URLQueryItem(name: "country", value: country),
                URLQueryItem(name: "productId", value: productId)
            ]
            return components.url?.absoluteString ?? ""
        }
    }
    
    var method: HTTPMethodType {
        return .get
    }
    
    var headers: [String: String] {
        return [
            "x-rapidapi-key": "82224e99dfmshcfacb3799da24edp19ab45jsn3e5ed1ee999e",
            "x-rapidapi-host": "vinted3.p.rapidapi.com"
        ]
    }
}


extension APIEndpoint {
    func request<T: Codable & Sendable>(
        modelType: T.Type,
        networkManager: NetworkManager,
        completion: @escaping @Sendable (Result<T, Error>) -> Void
    ) {
        networkManager.makeRequest(
            urlString: self.urlString,
            method: self.method,
            modelType: modelType.self,
            requestBody: nil as EmptyBody?,
            bearerToken: nil,
            headers: self.headers
        ) { result in
            completion(result)
        }
    }
}





