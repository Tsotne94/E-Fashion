//
//  ProductsCatalogViewModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 26.01.25.
//

import Foundation
import Combine

protocol ProductsCatalogViewModel: ProductsCatalogViewModelInput, ProductsCatalogViewModelOutput {
}

protocol ProductsCatalogViewModelInput{
    func viewDidLoad(id: Int)
    func backButtonTapped()
    func productTappedAt(index: Int)
    func categoryTapped(category: CategoryType)
    func presentSortingView()
    func presentFilterView()
    func dismissPresented()
    func fetchFavourites()
    var favourites: [Product] { get }
    var currentPage: Int { get }
    var id: Int? { get set }
    var orederType: OrderType { get set }
    var sortLabel: String { get }
    var products: [Product] { get }
    var cateogries: [String] { get }
    var isLoading: Bool { get }
    var parameters: SearchParameters { get }
}

protocol ProductsCatalogViewModelOutput {
    var output: AnyPublisher<ProductsCatalogViewModelOutputAction, Never> { get }
}

enum ProductsCatalogViewModelOutputAction {
    case productsFetched
    case sortingChanged
    case isLoading(Bool)
}

final class DefaultProductsCatalogViewModel: ProductsCatalogViewModel {
    @Inject private var fetchProductsUseCase: FetchProductsUseCase
    @Inject private var shopCorrdinator: ShopTabCoordinator
    @Inject private var fetchFavouritesUseCase: FetchFavouriteItemsUseCase
    
    lazy var orederType: OrderType = .newestFirst {
        didSet {
            if let id = id {
                viewDidLoad(id: id)
            }
            _output.send(.sortingChanged)
        }
    }
    
    var favourites: [Product] = []
    
    var currentPage: Int = 1
    var id: Int? = nil
    lazy var parameters: SearchParameters = SearchParameters(page: currentPage, order: orederType)
    
    var products: [Product] = []
    var cateogries: [String] = [
        "All",
        "Electronics",
        "Clothing",
        "Home Decor",
        "Books",
        "Accessories"
    ]
    var isLoading: Bool = false
    var sortLabel: String {
        orederType.rawValue
    }
    
    private var _output = PassthroughSubject<ProductsCatalogViewModelOutputAction, Never>()
    var output: AnyPublisher<ProductsCatalogViewModelOutputAction, Never> {
        _output.eraseToAnyPublisher()
    }

    private var subscriptions = Set<AnyCancellable>()
    
    public init() { }
   
    func viewDidLoad(id: Int) {
        self.id = id
        _output.send(.isLoading(true))
        
        let category = Category(id: id)
        parameters = SearchParameters(page: currentPage, order: orederType, category: category)
        
        fetchProductsUseCase.execute(params: parameters)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("successfully fetched hot items")
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] products in
                self?.products = products
                self?._output.send(.productsFetched)
                self?._output.send(.isLoading(false))
            }.store(in: &subscriptions)
    }
    
    func productTappedAt(index: Int) {
        shopCorrdinator.goToProductDetail(id: index)
    }
    
    func categoryTapped(category: CategoryType) {
        
    }
    
    func backButtonTapped() {
        shopCorrdinator.goBack(animated: true)
    }
    
    func presentSortingView() {
        shopCorrdinator.presentSortingViewController(nowSelected: orederType, viewModel: self)
    }
    
    func presentFilterView() {
        shopCorrdinator.presentFilterViewController(nowSelectedParameters: parameters, viewModel: self)
    }
    
    func dismissPresented() {
        shopCorrdinator.dismissPresented()
    }
    
    func fetchFavourites() {
        fetchFavouritesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("successfully fetched favourite items")
                    self?._output.send(.productsFetched)
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] products in
                self?.favourites = products
            }
            .store(in: &subscriptions)
    }
}
