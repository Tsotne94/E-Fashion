//
//  FirstTabViewModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//

import Foundation
import Combine

protocol BagViewModel: BagViewModelInput, BagViewModelOutput {
}

protocol BagViewModelInput {
    func fetchProducts()
    func goToProductDetail(id: Int)
    func deleteProduct(id: Int)
    func goToCheckout()
    var productsInCart: [ProductInCart] { get }
    var totalPrice: Double? { get }
    var images: [String: Data] { get }
    var isLoading: Bool { get }
}

protocol BagViewModelOutput {
    var output: AnyPublisher<BagViewModelOutputAction, Never> { get }
}

enum BagViewModelOutputAction {
    case productsFetched([ProductInCart])
    case productDeleted(Int)
    case imageLoaded(String, Data)
    case error(Error)
}

class DefaultBagViewModel: ObservableObject, BagViewModel {
    @Inject private var bagCoordinator: BagTabCoordinator
    @Inject private var fetchProductsInCartUseCase: FetchItemsInCartUseCase
    @Inject private var removeItemFromCartUseCase: RemoveWholeItemFromCartUseCase
    @Inject private var fetchImageUseCase: FetchImageUseCase
    
    @Published var productsInCart: [ProductInCart] = []
    @Published var totalPrice: Double? = nil
    @Published var images: [String: Data] = [:]
    @Published var isLoading: Bool = false
    
    private var _output = PassthroughSubject<BagViewModelOutputAction, Never>()
    var output: AnyPublisher<BagViewModelOutputAction, Never> {
        _output.eraseToAnyPublisher()
    }
    
    private var subscriptions = Set<AnyCancellable>()
    private var imageLoadingTasks: [String: AnyCancellable] = [:]
    
    public init() {
        setupBinding()
    }
    
    private func setupBinding() {
        self._output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .productsFetched(let products):
                    self?.productsInCart = products
                    self?.totalPrice = products.reduce(into: 0) { partialResult, product in
                        partialResult += product.product.price.totalAmount.asNumber()
                    }
                    self?.fetchImagesForProducts(products)
                    self?.isLoading = false
                case .productDeleted:
                    self?.fetchProducts()
                case .imageLoaded(let url, let data):
                    self?.images[url] = data
                case .error:
                    self?.isLoading = false
                    break
                }
            }
            .store(in: &subscriptions)
    }
    
    private func fetchImagesForProducts(_ products: [ProductInCart]) {
        let currentUrls = Set(products.flatMap { $0.product.images })
        imageLoadingTasks = imageLoadingTasks.filter { currentUrls.contains($0.key) }
        
        for product in products {
            for imageUrl in product.product.images {
                guard images[imageUrl] == nil else { continue }
                
                guard imageLoadingTasks[imageUrl] == nil else { continue }
                
                let task = fetchImageUseCase.execute(urlString: imageUrl)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] completion in
                        if case .failure(let error) = completion {
                            self?._output.send(.error(error))
                        }
                        self?.imageLoadingTasks.removeValue(forKey: imageUrl)
                    } receiveValue: { [weak self] imageData in
                        self?._output.send(.imageLoaded(imageUrl, imageData ?? Data()))
                    }
                
                imageLoadingTasks[imageUrl] = task
            }
        }
    }
    
    func goToProductDetail(id: Int) {
    }
    
    func deleteProduct(id: Int) {
        if let product = productsInCart.first(where: { $0.product.productId == id }) {
            for imageUrl in product.product.images {
                imageLoadingTasks[imageUrl]?.cancel()
                imageLoadingTasks.removeValue(forKey: imageUrl)
                images.removeValue(forKey: imageUrl)
            }
        }
        
        removeItemFromCartUseCase.execute(id: "\(id)")
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?._output.send(.productDeleted(id))
                case .failure(let error):
                    self?._output.send(.error(error))
                }
            } receiveValue: { _ in
                print("deleted item with id: \(id)")
            }
            .store(in: &subscriptions)
    }
    
    func goToCheckout() {
        
    }
    
    func fetchProducts() {
        isLoading = true
        fetchProductsInCartUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] products in
                self?._output.send(.productsFetched(products))
            }
            .store(in: &subscriptions)
    }
}
