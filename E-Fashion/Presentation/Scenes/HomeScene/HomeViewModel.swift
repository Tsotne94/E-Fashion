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
    func fetchNew()
    func fetchSale()
}

protocol HomeViewModelOutput {
    var newItems: [Product] { get }
    var hotItems: [Product] { get }
    var newItemsPage: Int { get }
    var hotItemsPage: Int { get }
    var isLoadingMore: CurrentValueSubject<Bool, Never> { get }
    var output: AnyPublisher<HomeViewModelOutputAction, Never> { get }
}

enum HomeViewModelOutputAction {
    case showProductDetails(Product)
    case showError(String)
}

final class DefaultHomeViewModelOutput: HomeViewModel {
    @Inject private var mainCoordinator: MainCoordinator
    @Inject private var fetchProductsUseCase: FetchProductsUseCase
    var newItems: [Product] = []
    var hotItems: [Product] = []
    var newItemsPage: Int = 0
    var hotItemsPage: Int = 0
    
    var isLoadingMore = CurrentValueSubject<Bool, Never>(false)
    
    private var _output = PassthroughSubject<HomeViewModelOutputAction, Never>()
    var output: AnyPublisher<HomeViewModelOutputAction, Never> {
        _output.eraseToAnyPublisher()
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    public init() { }
    
    func viewDidLoad() {
        fetchNew()
        fetchSale()
    }
    
    func productTapped(productId: Int) {
        
    }
    
    func fetchNew() {
        newItemsPage += 1
        let category = Category(id: Categories.menId)
        let params = SearchParameters(page: newItemsPage, order: .newestFirst, category: category)
        
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
                self?.newItems += products
            }.store(in: &subscriptions)

    }
    
    func fetchSale() {
        hotItemsPage += 1
        let category = Category(id: Categories.womanId)
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

