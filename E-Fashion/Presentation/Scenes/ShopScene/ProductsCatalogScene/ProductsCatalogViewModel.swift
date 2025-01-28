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
    func viewDidLoad()
    func backButtonTapped()
    func productTappedAt(index: Int)
    func categoryTapped(category: CategoryType)
    func presentSortingView()
    func presentFilterView()
    func dismissPresented()
    var currentPage: Int { get }
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
    
    var orederType: OrderType = .newestFirst {
        didSet {
            viewDidLoad()
            _output.send(.sortingChanged)
        }
    }
    var currentPage: Int = 1
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
    
    func viewDidLoad() {
        _output.send(.isLoading(true))
        let category = Category(id: Categories.allMenIds[Int.random(in: 0...9)])
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
}
