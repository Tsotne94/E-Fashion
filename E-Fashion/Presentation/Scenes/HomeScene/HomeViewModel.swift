//
//  HomeViewModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

import Foundation
import Combine

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
}
