//
//  APIEndpoint.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.

import MyNetworkManager
import Foundation

public final class APIEndpoint {
    static let shared = APIEndpoint()
    private init() {}
    
    private var baseURL: String {
        return "https://vinted3.p.rapidapi.com"
    }
    
    private var headers: [String: String] {
        return [
            "x-rapidapi-key": "82224e99dfmshcfacb3799da24edp19ab45jsn3e5ed1ee999e",
            "x-rapidapi-host": "vinted3.p.rapidapi.com"
        ]
    }
    
    private let requestQueue = DispatchQueue(label: "com.apiEndpoint.requestQueue")
    private var lastRequestTime: Date = .distantPast
    
    private let throttleInterval: TimeInterval = 2.0

    func search(parameters: SearchParameters) -> String {
        var components = URLComponents(string: baseURL + "/getSearch")!
        components.queryItems = parameters.toQueryItems()
        let urlString = components.url?.absoluteString ?? ""
        print("Generated URL: \(urlString)")
        return urlString
    }
    
    func getProduct(productId: String, country: String = "us") -> String {
        var components = URLComponents(string: baseURL + "/getProduct")!
        components.queryItems = [
            URLQueryItem(name: "country", value: country),
            URLQueryItem(name: "productId", value: productId)
        ]
        return components.url?.absoluteString ?? ""
    }
    
    func request<T: Codable & Sendable>(
        urlString: String,
        modelType: T.Type,
        networkManager: NetworkManager,
        completion: @escaping @Sendable (Result<T, Error>) -> Void
    ) {
        requestQueue.async { [weak self] in
            guard let self = self else { return }
            
            let now = Date()
            let timeSinceLastRequest = now.timeIntervalSince(self.lastRequestTime)
            
            if timeSinceLastRequest < self.throttleInterval {
                let delay = self.throttleInterval - timeSinceLastRequest
                Thread.sleep(forTimeInterval: delay)
            }
            
            self.lastRequestTime = Date()
            
            networkManager.makeRequest(
                urlString: urlString,
                method: .get,
                modelType: modelType.self,
                requestBody: nil as EmptyBody?,
                bearerToken: nil,
                headers: self.headers
            ) { result in
                completion(result)
            }
        }
    }
}
