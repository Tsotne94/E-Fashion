//
//  HomeViewModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

import Foundation
import Combine
import MyNetworkManager

protocol HomeViewModel: AnyObject, HomeViewModelInput, HomeViewModelOutput {}

protocol HomeViewModelInput {
    func productTapped(productId: Int)
    func fetchFavourites()
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
    case showError(String)
    case isLoading(Bool)
}

final class DefaultHomeViewModel: HomeViewModel {
    @Inject private var homeCoordinator: HomeTabCoordinator
    @Inject private var fetchProductsUseCase: FetchProductsUseCase
    @Inject private var fetchFavouriteItemsUseCase: FetchFavouriteItemsUseCase
    
    private let categories = Categories()
    
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
    
    public init() {}
    
    func productTapped(productId: Int) {
        homeCoordinator.goToProductsDetails(productId: productId)
    }
    
    func fetchNew() {
        guard let newSection = categories.getSection(for: .women, sectionType: .accessories) else { return }
        
        let category = Category(id: newSection.id, title: newSection.title, parentId: newSection.parentId)
        let params = SearchParameters(page: newItemsPage, order: .newestFirst, category: category)
        
        fetchProductsUseCase.execute(params: params)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("successfully fetched new items")
                    self?._output.send(.isLoading(false))
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                    self?._output.send(.isLoading(false))
                }
            } receiveValue: { [weak self] products in
                self?.newItems = products
            }
            .store(in: &subscriptions)
    }
    
    func fetchHot() {
        guard let clothesSection = categories.getSection(for: .women, sectionType: .shoes),
              let randomItem = clothesSection.items.randomElement() else { return }
        
        let params = SearchParameters(page: hotItemsPage, order: .relevance, category: randomItem)
        
        fetchProductsUseCase.execute(params: params)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("successfully fetched new items")
                    self?._output.send(.isLoading(false))
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                    self?._output.send(.isLoading(false))
                }
            } receiveValue: { [weak self] products in
                self?.hotItems = products.sorted(by: { $0.promoted && !$1.promoted })
            }
            .store(in: &subscriptions)
    }
    
    func fetchFavourites() {
        fetchFavouriteItemsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("successfully fetched favourite items")
                    self?._output.send(.productsFetched)
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                    self?._output.send(.showError(error.localizedDescription))
                }
            } receiveValue: { products in
                FavouriteProducts.products = products
            }
            .store(in: &subscriptions)
    }
}
