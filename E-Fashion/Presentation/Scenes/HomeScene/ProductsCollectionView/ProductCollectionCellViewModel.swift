//
//  ProductImageViewModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 24.01.25.
//

import UIKit
import Combine

protocol ProductCollectionCellViewModel: ProductCollectionCellViewModelInput, ProductCollectionCellViewModelOutput {}

protocol ProductCollectionCellViewModelInput {
    func loadImage(urlString: String, size: CGSize)
    func cancelLoading()
    func favouritesTapped()
    func loadFavouritesState()
    func updateFavouriteProducts(_ products: [Product])
    var isFavourite: Bool { get }
    var product: Product? { get set }
}

protocol ProductCollectionCellViewModelOutput {
    var output: AnyPublisher<ProductCollectionCellViewModelOutputAction, Never> { get }
}

enum ProductCollectionCellViewModelOutputAction {
    case imageLoaded(UIImage?)
    case favouriteStatusChanged
    case showError(String)
}

final class DefaultProductCollectionCellViewModel: ProductCollectionCellViewModel {
    @Inject private var fetchImageUseCase: FetchImageUseCase
    @Inject private var retrieveCachedImageUseCase: RetriveCachedImageUseCase
    @Inject private var addToFavouritesUseCase: AddToFavouritesUseCase
    @Inject private var removeFromFavouritesUseCase: RemoveFromFavouritesUseCase
    
    private var favouriteProducts: [Product] = []
    var isFavourite: Bool {
        guard let product = product else { return false }
        return favouriteProducts.contains(where: { $0.productId == product.productId })
    }
    
    var product: Product?
    
    private lazy var productId: String = {
        return "\(product?.productId ?? 0)"
    }()
    
    private let outputSubject = PassthroughSubject<ProductCollectionCellViewModelOutputAction, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    var output: AnyPublisher<ProductCollectionCellViewModelOutputAction, Never> {
        outputSubject.eraseToAnyPublisher()
    }
    
    init() {}
    
    deinit {
        cancelLoading()
    }
    
    func updateFavouriteProducts(_ products: [Product]) {
        favouriteProducts = products
        outputSubject.send(.favouriteStatusChanged)
    }
    
    func loadImage(urlString: String, size: CGSize) {
        cancelLoading()
        
        retrieveCachedImageUseCase.execute(url: urlString)
            .map { Optional.some($0) }
            .catch { _ -> AnyPublisher<Data?, Never> in
                self.fetchImageUseCase.execute(urlString: urlString)
            }
            .compactMap { data -> UIImage? in
                guard let data = data,
                      let image = UIImage(data: data) else { return nil }
                
                let scaledImage = image.downsample(to: size, scale: UIScreen.main.scale)
                return scaledImage
            }
            .sink { [weak self] image in
                self?.outputSubject.send(.imageLoaded(image))
            }
            .store(in: &subscriptions)
    }
    
    func cancelLoading() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    func favouritesTapped() {
        guard let product = product else {
            outputSubject.send(.showError("No product available"))
            return
        }
        
        if isFavourite {
            removeFromFavourites(product: product)
        } else {
            addToFavourites(product: product)
        }
    }
    
    private func addToFavourites(product: Product) {
        favouriteProducts.append(product)
        outputSubject.send(.favouriteStatusChanged)
        
        addToFavouritesUseCase.execute(product: product)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.favouriteProducts.removeAll(where: { $0.productId == product.productId })
                    self?.outputSubject.send(.favouriteStatusChanged)
                    self?.outputSubject.send(.showError(error.localizedDescription))
                }
            } receiveValue: { _ in }
            .store(in: &subscriptions)
    }
    
    private func removeFromFavourites(product: Product) {
        favouriteProducts.removeAll(where: { $0.productId == product.productId })
        outputSubject.send(.favouriteStatusChanged)
        
        removeFromFavouritesUseCase.execute(id: productId)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.favouriteProducts.append(product)
                    self?.outputSubject.send(.favouriteStatusChanged)
                    self?.outputSubject.send(.showError(error.localizedDescription))
                }
            } receiveValue: { _ in }
            .store(in: &subscriptions)
    }
    
    func loadFavouritesState() {
        outputSubject.send(.favouriteStatusChanged)
    }
}
