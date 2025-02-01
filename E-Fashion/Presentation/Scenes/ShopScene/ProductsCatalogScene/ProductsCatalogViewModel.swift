//
//  ProductsCatalogViewModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 26.01.25.
//

import Foundation
import Combine

protocol ProductsCatalogViewModel: ProductsCatalogViewModelInput, ProductsCatalogViewModelOutput {}

protocol ProductsCatalogViewModelInput {
    func viewDidLoad(id: Int)
    func fetchProducts(for id: Int, isRetry: Bool)
    func searchProduct(query: String)
    func backButtonTapped()
    func productTappedAt(index: Int)
    func presentSortingView()
    func presentFilterView()
    func dismissPresented()
    func fetchWithFilters(minPrice: Int?, maxPrice: Int?, selectedColors: [ProductColor]?, selectedMaterials: [ProductMaterial]?, selectedConditions: [ProductCondition]?)
    var currentPage: Int { get }
    var id: Int? { get set }
    var orderType: OrderType { get set }
    var sortLabel: String { get }
    var products: [Product] { get }
    var cateogries: [Category] { get }
    var isLoading: Bool { get }
    var parameters: SearchParameters { get }
}

protocol ProductsCatalogViewModelOutput {
    var output: AnyPublisher<ProductsCatalogViewModelOutputAction, Never> { get }
}

enum ProductsCatalogViewModelOutputAction {
    case productsFetched
    case sortingChanged
    case subCategoriesFetched
    case isLoading(Bool)
    case nothingFound
}

final class DefaultProductsCatalogViewModel: ProductsCatalogViewModel {
    @Inject private var fetchProductsUseCase: FetchProductsUseCase
    @Inject private var shopCorrdinator: ShopTabCoordinator
    @Inject private var fetchFavouritesUseCase: FetchFavouriteItemsUseCase
    
    private var _output = PassthroughSubject<ProductsCatalogViewModelOutputAction, Never>()
    var output: AnyPublisher<ProductsCatalogViewModelOutputAction, Never> {
        _output.eraseToAnyPublisher()
    }
    
    lazy var orderType: OrderType = .newestFirst {
        didSet {
            parameters = SearchParameters(
                page: currentPage,
                order: orderType,
                query: parameters.query,
                category: parameters.category,
                colors: parameters.colors,
                materials: parameters.materials,
                conditions: parameters.conditions,
                minPrice: parameters.minPrice,
                maxPrice: parameters.maxPrice
            )
            if let id = id, isLoading == false {
                fetchProducts(for: id)
            }
            _output.send(.sortingChanged)
        }
    }
    
    var currentPage: Int = 1
    var id: Int? = nil
    
    lazy var parameters: SearchParameters = SearchParameters(page: currentPage, order: orderType)
    
    var products: [Product] = []
    var cateogries: [Category] = [] {
        didSet {
            _output.send(.subCategoriesFetched)
        }
    }
    var isLoading: Bool = true
    var sortLabel: String {
        orderType.name()
    }
    
    private var subscriptions = Set<AnyCancellable>()
    private var searchSubscription: AnyCancellable?
    private var searchSubject = PassthroughSubject<String, Never>()
    
    public init() {
        setupSearchSubscription()
    }
    
    private func setupSearchSubscription() {
        searchSubscription = searchSubject
            .debounce(for: .milliseconds(1000), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
    }
    
    func viewDidLoad(id: Int) {
        _output.send(.isLoading(true))
        self.id = id
        self.cateogries = Categories().getSubcategoryItems(id: id)
        fetchProducts(for: id)
    }
    
    func fetchProducts(for id: Int, isRetry: Bool = false) {
        self.id = id
        _output.send(.isLoading(true))
        
        let category = Category(id: id)
        let updatedParams = parameters
        updatedParams.category = category
        
        fetchProductsUseCase.execute(params: updatedParams)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print("Error: \(error.localizedDescription)")
                    self?._output.send(.isLoading(false))
                }
            } receiveValue: { [weak self] products in
                if !products.isEmpty {
                    self?.products = products
                    self?._output.send(.productsFetched)
                } else {
                    self?._output.send(isRetry ? .productsFetched : .nothingFound)
                }
                self?._output.send(.isLoading(false))
            }
            .store(in: &subscriptions)
    }
    
    func fetchWithFilters(minPrice: Int?, maxPrice: Int?, selectedColors: [ProductColor]?, selectedMaterials: [ProductMaterial]?, selectedConditions: [ProductCondition]?) {
        guard let id = id else { return }
        
        _output.send(.isLoading(true))
        
        let filterParams = SearchParameters(
            page: currentPage,
            order: parameters.order,
            query: parameters.query,
            category: Category(id: id),
            colors: selectedColors,
            materials: selectedMaterials,
            conditions: selectedConditions,
            minPrice: minPrice,
            maxPrice: maxPrice
        )
        
        fetchProductsUseCase.execute(params: filterParams)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print("Error: \(error.localizedDescription)")
                    self?._output.send(.isLoading(false))
                }
            } receiveValue: { [weak self] products in
                if !products.isEmpty {
                    self?.products = products
                    self?._output.send(.productsFetched)
                } else {
                    self?._output.send(.nothingFound)
                }
                self?._output.send(.isLoading(false))
            }
            .store(in: &subscriptions)
    }
    
    func searchProduct(query: String) {
        searchSubject.send(query)
    }
    
    private func performSearch(query: String) {
        guard !query.isEmpty, let id = id else { return }
        
        _output.send(.isLoading(true))
        
        let newParams = SearchParameters(
            page: currentPage,
            order: .relevance,
            query: query,
            category: Category(id: id),
            colors: parameters.colors,
            materials: parameters.materials,
            conditions: parameters.conditions,
            minPrice: parameters.minPrice,
            maxPrice: parameters.maxPrice
        )
        
        fetchProductsUseCase.execute(params: newParams)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print("Error: \(error.localizedDescription)")
                    self?._output.send(.isLoading(false))
                }
            } receiveValue: { [weak self] products in
                if !products.isEmpty {
                    self?.products = products
                    self?._output.send(.productsFetched)
                    self?._output.send(.isLoading(false))
                } else {
                    self?._output.send(.nothingFound)
                }
            }
            .store(in: &subscriptions)
    }
    
    func productTappedAt(index: Int) {
        shopCorrdinator.goToProductDetail(id: index)
    }
    
    func backButtonTapped() {
        shopCorrdinator.goBack(animated: true)
    }
    
    func presentSortingView() {
        shopCorrdinator.presentSortingViewController(nowSelected: orderType, viewModel: self)
    }
    
    func presentFilterView() {
        shopCorrdinator.presentFilterViewController(nowSelectedParameters: parameters, viewModel: self)
    }
    
    func dismissPresented() {
        shopCorrdinator.dismissPresented()
    }
}
