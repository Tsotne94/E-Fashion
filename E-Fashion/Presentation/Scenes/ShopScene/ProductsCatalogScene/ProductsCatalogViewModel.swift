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
    var currentPage: Int { get }
    var orederType: OrderType { get }
    var sortLabel: String { get }
    var products: [Product] { get }
    var cateogries: [String] { get }
    var isLoading: Bool { get }
}

protocol ProductsCatalogViewModelOutput {
    var output: AnyPublisher<ProductsCatalogViewModelOutputAction, Never> { get }
}

enum ProductsCatalogViewModelOutputAction {
    case productsFetched
    case sortingChanged
}

final class DefaultProductsCatalogViewModel: ProductsCatalogViewModel {
    @Inject private var fetchProductsUseCase: FetchProductsUseCase
    @Inject private var shopCorrdinator: ShopTabCoordinator
    
    var orederType: OrderType = .newestFirst
    var currentPage: Int = 1
    var products: [Product] = []
    var cateogries: [String] = [
        "All",
        "Electronics",
        "Clothing",
        "Home Decor",
        "Books",
        "Accessories"
    ]
    var isLoading: Bool = true
    var sortLabel: String = "Low to High"
    
    private var _output = PassthroughSubject<ProductsCatalogViewModelOutputAction, Never>()
    var output: AnyPublisher<ProductsCatalogViewModelOutputAction, Never> {
        _output.eraseToAnyPublisher()
    }

    private var subscriptions = Set<AnyCancellable>()
    
    public init() { }
    
    func viewDidLoad() {
        let category = Category(id: Categories.allMenIds[Int.random(in: 0...9)])
        let params = SearchParameters(page: currentPage, order: orederType, category: category)
        
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
                self?.products = products
                self?._output.send(.productsFetched)
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
}
