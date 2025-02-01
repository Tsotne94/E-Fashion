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
    func addToFavourites(product: Product)
    func removeFromFavourites(product: Product)
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
    
    var product: Product?
    
    var isFavourite: Bool {
        guard let currentProduct = product else { return false }
        return FavouriteProducts.products.contains(where: { $0.productId == currentProduct.productId })
    }
    
    private var productId: String {
        return "\(product?.productId ?? 0)"
    }
    
    private let _output = PassthroughSubject<ProductCollectionCellViewModelOutputAction, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    var output: AnyPublisher<ProductCollectionCellViewModelOutputAction, Never> {
        _output.eraseToAnyPublisher()
    }
    
    init() { }
    
    deinit {
        cancelLoading()
    }
    
    func favouritesTapped() {
        guard let product = product else {
            _output.send(.showError("No product available"))
            return
        }
        
        if isFavourite {
            removeFromFavourites(product: product)
        } else {
            addToFavourites(product: product)
        }
    }
    
    func addToFavourites(product: Product) {
        addToFavouritesUseCase.execute(product: product)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?._output.send(.showError(error.localizedDescription))
                }
            } receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                if !FavouriteProducts.products.contains(where: { $0.productId == product.productId }) {
                    FavouriteProducts.products.append(product)
                }
                self._output.send(.favouriteStatusChanged)
            }.store(in: &subscriptions)
    }
    
    func removeFromFavourites(product: Product) {
        removeFromFavouritesUseCase.execute(id: productId)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?._output.send(.showError(error.localizedDescription))
                }
            } receiveValue: { [weak self] _ in
                guard let self = self else { return }
                FavouriteProducts.products.removeAll { $0.productId == product.productId }
                self._output.send(.favouriteStatusChanged)
            }.store(in: &subscriptions)
    }
    
    func cancelLoading() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
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
                self?._output.send(.imageLoaded(image))
            }
            .store(in: &subscriptions)
    }
}
