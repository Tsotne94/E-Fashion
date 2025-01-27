//
//  HomeViewModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

import Foundation
import Combine
import MyNetworkManager

protocol HomeViewModel: AnyObject, HomeViewModelInput, HomeViewModelOutput {
}

protocol HomeViewModelInput {
    func productTapped(productId: Int)
    func fetchNew()
    func fetchHot()
}

protocol HomeViewModelOutput {
    var newItems: [Product] { get }
    var hotItems: [Product] { get }
    var newItemsPage: Int { get }
    var hotItemsPage: Int { get }
    var output: AnyPublisher<HomeViewModelOutputAction, Never> { get }
}

enum HomeViewModelOutputAction {
    case productsFetched
    case showProductDetails(Product)
    case showError(String)
}

final class DefaultHomeViewModel: HomeViewModel {
    @Inject private var homeCoordinator: HomeTabCoordinator
    @Inject private var fetchProductsUseCase: FetchProductsUseCase
    
    var newItems: [Product] = [] {
        didSet {
            _output.send(.productsFetched)
        }
    }
    var hotItems: [Product] = [] {
        didSet {
            _output.send(.productsFetched)
        }
    }
    var newItemsPage: Int = 1
    var hotItemsPage: Int = 1
    
    private var _output = PassthroughSubject<HomeViewModelOutputAction, Never>()
    var output: AnyPublisher<HomeViewModelOutputAction, Never> {
        _output.eraseToAnyPublisher()
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    public init() { }
    
    func productTapped(productId: Int) {
        homeCoordinator.goToProductsDetails(productId: productId)
    }
    
    func fetchNew() {
        let category = Category(id: Categories.allMenIds[Int.random(in: 0...9)])
        let params = SearchParameters(page: newItemsPage, order: .newestFirst, category: category)
        
        fetchProductsUseCase.execute(params: params)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("successfully fetched hot items")
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] products in
                self?.newItems += products
            }.store(in: &subscriptions)

    }
    
    func fetchHot() {
        let category = Category(id: Categories.allMenIds[Int.random(in: 0...9)])
        let params = SearchParameters(page: hotItemsPage, order: .relevance, category: category)
        
        fetchProductsUseCase.execute(params: params)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("successfully fetched new items")
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] products in
                self?.hotItems += products.sorted(by: { $0.promoted && !$1.promoted })
            }.store(in: &subscriptions)
    }
}
