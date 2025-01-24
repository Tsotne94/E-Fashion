//
//  ProductImageViewModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 24.01.25.
//

import UIKit
import Combine

protocol ProductImageViewModel {
    var imagePublisher: AnyPublisher<UIImage?, Never> { get }
    func loadImage(urlString: String, size: CGSize)
    func cancelLoading()
}

final class DefaultProductImageViewModel: ProductImageViewModel {
    @Inject private var fetchImageUseCase: FetchImageUseCase
    @Inject private var retrieveCachedImageUseCase: RetriveCachedImageUseCase
    
    private let imageSubject = CurrentValueSubject<UIImage?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()
    
    var imagePublisher: AnyPublisher<UIImage?, Never> {
        imageSubject.eraseToAnyPublisher()
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
                self?.imageSubject.send(image)
            }
            .store(in: &cancellables)
    }
    
    func cancelLoading() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
