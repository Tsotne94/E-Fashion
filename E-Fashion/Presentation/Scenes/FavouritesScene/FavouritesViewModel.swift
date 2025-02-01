//
//  FavouritesViewModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 29.01.25.
//

import Combine
import Foundation

protocol FavouritesViewModel {
}

protocol FavouritesViewModelInput {
    func fetchProducts()
    func deleteProduct(id: Int)
    func addToCart(id: Int)
    func fetchItemsinCart()
    var favouriteProducts: [Product] { get }
    var images: [String: Data] { get }
    var isLoading: Bool { get }
}

protocol FavouritesViewModelOutput {
    var output: AnyPublisher<FavouritesViewModelOutputAction, Never> { get }
}

enum FavouritesViewModelOutputAction {
    case productsFetched([Product])
    case productDeleted(Int)
    case imageLoaded(String, Data)
    case error(Error)
    case isLoading(Bool)
}

class DefaultFavouritesViewModel: ObservableObject, FavouritesViewModel, FavouritesViewModelInput, FavouritesViewModelOutput {
    @Inject private var favouritesCoordinator: FavouritesTabCoordinator
    
    @Inject private var fetchFavouriteProductsUseCase: FetchFavouriteItemsUseCase
    @Inject private var removeFromFavouritesUseCase: RemoveFromFavouritesUseCase
    @Inject private var fetchProductDetailsUseCase: FetchSingleProductUseCase
    @Inject private var fetchItemsInCartUseCase: FetchItemsInCartUseCase
    @Inject private var addToCartUseCase: AddToCartUseCase
    @Inject private var fetchImageUseCase: FetchImageUseCase
    
    @Published private(set) var favouriteProducts: [Product] = []
    @Published private(set) var images: [String: Data] = [:]
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isInCart: [Int: Bool] = [:]
    
    private var _output = PassthroughSubject<FavouritesViewModelOutputAction, Never>()
    var output: AnyPublisher<FavouritesViewModelOutputAction, Never> {
        _output.eraseToAnyPublisher()
    }
    
    private var subscriptions = Set<AnyCancellable>()
    private var imageLoadingTasks: [String: AnyCancellable] = [:]
    
    public init() {
        setupBinding()
        fetchItemsinCart()
    }
    
    private func setupBinding() {
        self._output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .productsFetched(let products):
                    self?.favouriteProducts = products
                    self?.fetchImagesForProducts(products)
                    self?.isLoading = false
                case .productDeleted:
                    self?.fetchProducts()
                case .imageLoaded(let url, let data):
                    self?.images[url] = data
                case .isLoading(let value):
                    self?.isLoading = value
                case .error:
                    self?.isLoading = false
                }
            }
            .store(in: &subscriptions)
    }
    
    private func fetchImagesForProducts(_ products: [Product]) {
        let currentUrls = Set(products.map { $0.image })
        imageLoadingTasks = imageLoadingTasks.filter { currentUrls.contains($0.key) }
        
        for product in products {
            let imageUrl = product.image
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
    
    func goToProductDetail(id: Int) {
        favouritesCoordinator.goToProductsDetails(productId: id)
    }
    
    func deleteProduct(id: Int) {
        if let product = favouriteProducts.first(where: { $0.productId == id }) {
            let imageUrl = product.image
            imageLoadingTasks[imageUrl]?.cancel()
            imageLoadingTasks.removeValue(forKey: imageUrl)
            images.removeValue(forKey: imageUrl)
            isInCart.removeValue(forKey: id)
        }
        
        removeFromFavouritesUseCase.execute(id: "\(id)")
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?._output.send(.productDeleted(id))
                    FavouriteProducts.products.removeAll(where: { $0.productId == id })
                case .failure(let error):
                    self?._output.send(.error(error))
                }
            } receiveValue: { _ in
                print("removed item from favourites with id: \(id)")
            }
            .store(in: &subscriptions)
    }
    
    func addToCart(id: Int) {
        _output.send(.isLoading(true))
        
        let productDetailsPublisher = fetchProductDetailsUseCase.execute(id: "\(id)")
        
        let addToCartPublisher = productDetailsPublisher
            .flatMap { details -> AnyPublisher<Void, Error> in
                let productInCart = ProductInCart(id: "\(id)", product: details, quantity: 1)
                return self.addToCartUseCase.execute(product: productInCart)
            }
            .receive(on: DispatchQueue.main)
        
        addToCartPublisher
            .sink { [weak self] completion in
                self?._output.send(.isLoading(false))
                
                switch completion {
                case .finished:
                    print("Successfully added item to cart with id: \(id)")
                    self?.isInCart[id] = true
                case .failure(let error):
                    self?._output.send(.error(error))
                }
            } receiveValue: { _ in }
            .store(in: &subscriptions)
    }

    func fetchProducts() {
        isLoading = true
        fetchFavouriteProductsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?._output.send(.error(error))
                    self?._output.send(.isLoading(false))
                }
            }, receiveValue: { [weak self] products in
                self?._output.send(.productsFetched(products))
                FavouriteProducts.products = products
            })
            .store(in: &subscriptions)
    }
    
    func fetchItemsinCart() {
        fetchItemsInCartUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Successfully fetched items in cart")
                case .failure(let error):
                    self._output.send(.error(error))
                }
            } receiveValue: { [weak self] products in
                self?.isInCart.removeAll()
                
                products.forEach { product in
                    if let productId = Int(product.id) {
                        self?.isInCart[productId] = true
                    }
                }
            }
            .store(in: &subscriptions)
    }
}
