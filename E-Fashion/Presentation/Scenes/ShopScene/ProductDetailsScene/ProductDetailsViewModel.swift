//
//  ProductDetailsViewModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 27.01.25.
//

import Foundation
import Combine

protocol ProductDetailsViewModel: ProductDetailsViewModelInput, ProductDetailsViewModelOutput {
}

protocol ProductDetailsViewModelInput {
    func viewDidLoad(productId: Int)
    func addToFavourites()
    func removeFromFavourites()
    func addToCart()
    func shareButtonTapped()
    func goBack()
    var inCart: Bool { get set }
    var product: ProductDetails? { get set }
    var images: [Data] { get }
    var isFavourite: Bool { get }
}

protocol ProductDetailsViewModelOutput {
    var output: AnyPublisher<ProductDetailsViewModelOutputAction, Never> { get }
}

enum ProductDetailsViewModelOutputAction {
    case infoFetched
    case imagesFetched
    case favouritesUpdated
    case addedToCart
    case isLoading(Bool)
    case isInCartFetched
    case failedToAddInCart
    case failedToAddInFavourites
}

final class DefaultProductDetailsViewModel: ProductDetailsViewModel {
    @Inject private var shopCoordinator: ShopTabCoordinator
    
    @Inject private var fetchProductDetailsUseCase: FetchSingleProductUseCase
    @Inject private var addToCartUseCase: AddToCartUseCase
    @Inject private var removeFromFavouritesUseCase: RemoveFromFavouritesUseCase
    @Inject private var addToFavouritesUseCase: AddToFavouritesUseCase
    @Inject private var isInCartUseCase: IsInCartUseCase
    @Inject private var fetchImageUseCase: FetchImageUseCase
    
    var product: ProductDetails? = nil
    var images: [Data] = []
    
    private var _output = PassthroughSubject<ProductDetailsViewModelOutputAction, Never>()
    var output: AnyPublisher<ProductDetailsViewModelOutputAction, Never> {
        _output.eraseToAnyPublisher()
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var inCart: Bool = false
    @Published  var isFavourite: Bool = false
    
    private func updateFavouriteState() {
        guard let currentProduct = product else { return }
        isFavourite = FavouriteProducts.products.contains(where: { $0.productId == currentProduct.productId })
    }
    
    func viewDidLoad(productId: Int) {
        _output.send(.isLoading(true))
        
        fetchProductDetailsUseCase.execute(id: "\(productId)")
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("successfully fetched product details")
                case .failure(let error):
                    print("failed to fetch product Details: \(error)")
                }
            } receiveValue: { [weak self] product in
                self?.product = product
                self?.fetchImages()
                self?.updateFavouriteState()
                self?._output.send(.infoFetched)
                self?._output.send(.isLoading(false))
            }.store(in: &subscriptions)
        
        isInCartUseCase.execute(id: "\(productId)")
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("successfully checked cart status")
                case .failure(let error):
                    print("failed to check cart status: \(error)")
                }
            } receiveValue: { [weak self] isInCart in
                self?.inCart = isInCart
            }.store(in: &subscriptions)
    }
    
    func addToFavourites() {
        guard let product = product else {
            _output.send(.failedToAddInFavourites)
            return
        }
        
        let convertedProduct = product.toProduct()
        addToFavouritesUseCase.execute(product: convertedProduct)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    FavouriteProducts.products.append(convertedProduct)
                    self?.isFavourite = true
                case .failure(_):
                    self?._output.send(.failedToAddInFavourites)
                }
            } receiveValue: { _ in
                print("successfully added to favourites")
            }.store(in: &subscriptions)
    }
    
    func removeFromFavourites() {
        guard let productId = product?.productId else { return }
        
        removeFromFavouritesUseCase.execute(id: "\(productId)")
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("successfully removed from favourites")
                    FavouriteProducts.products.removeAll(where: { $0.productId == productId })
                    self?.isFavourite = false
                case .failure(let error):
                    print("failed to remove from favourites: \(error)")
                }
            } receiveValue: { _ in
                print("successfully removed from favourites")
            }.store(in: &subscriptions)
    }
    
    private func fetchImages() {
        guard let product = product else { return }
        
        let limitedUrls = Array(product.images.prefix(3))
        
        let publishers = limitedUrls.map { url in
            fetchImageUseCase.execute(urlString: url)
                .eraseToAnyPublisher()
        }
        
        Publishers.MergeMany(publishers)
            .collect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageDataArray in
                self?.images = imageDataArray.compactMap({ $0 }).filter { !$0.isEmpty }
                self?._output.send(.imagesFetched)
            }
            .store(in: &subscriptions)
    }
    
    func addToCart() {
        guard let product = product else {
            _output.send(.failedToAddInCart)
            return
        }
        
        let productInCart = ProductInCart(id: "\(product.productId)", product: product, quantity: 1)
        addToCartUseCase.execute(product: productInCart)
            .sink { [weak self] completions in
                switch completions {
                case .finished:
                    print("successfully added in cart")
                case .failure(_):
                    self?._output.send(.failedToAddInCart)
                }
            } receiveValue: { [weak self] Void in
                self?._output.send(.addedToCart)
                self?.inCart = true
                self?._output.send(.isInCartFetched)
            }.store(in: &subscriptions)
    }
    
    func shareButtonTapped() {
        
    }
    
    func goBack() {
        shopCoordinator.goBack(animated: true)
    }
}
