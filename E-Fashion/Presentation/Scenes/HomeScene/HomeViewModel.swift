//
//  HomeViewModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

import Foundation
import Combine
import MyNetworkManager

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput {
}

protocol HomeViewModelInput {
    func viewDidLoad()
    func productTapped(productId: Int)
    func fetchMoreNew()
    func fetchMoreSale()
}

protocol HomeViewModelOutput {
    var newItems: [Product] { get }
    var saleItems: [Product] { get }
    var isLoadingMore: CurrentValueSubject<Bool, Never> { get }
    var output: AnyPublisher<HomeViewModelOutputAction, Never> { get }
}

enum HomeViewModelOutputAction {
    case showProductDetails(Product)
    case showError(String)
}

final class DefaultHomeViewModelOutput: HomeViewModel {
    var newItems: [Product] = []
    var saleItems: [Product] = []
    
    var isLoadingMore = CurrentValueSubject<Bool, Never>(false)
    
    private var _output = PassthroughSubject<HomeViewModelOutputAction, Never>()
    var output: AnyPublisher<HomeViewModelOutputAction, Never> {
        _output.eraseToAnyPublisher()
    }
    
    public init() {
    }
    
    func viewDidLoad() {
        
    }
    
    func productTapped(productId: Int) {
        
    }
    
    func fetchMoreNew() {
        
    }
    
    func fetchMoreSale() {
        
    }
    
    
    func temp() {
        let search = SearchParameters(page: 1, order: .newestFirst)
        let endpoint = APIEndpoint.search(search)
        endpoint.request(
            modelType: [Product].self,  
            networkManager: NetworkManager()
        ) { result in
            switch result {
            case .success(let products):
                print("Success! Number of products: \(products.count)")
                products.forEach { product in
                    print("Product: \(product.title), Price: \(product.price.totalAmount) \(product.price.totalAmount.currency_code)")
                }
            case .failure(let error):
                print("Failed with error: \(error)")
            }
        }
    }
}

