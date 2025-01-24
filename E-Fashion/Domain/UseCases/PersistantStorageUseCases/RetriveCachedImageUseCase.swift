//
//  RetriveCashedImageUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 22.01.25.
//
import Foundation
import Combine

protocol RetriveCachedImageUseCase {
    func execute(url: String) -> AnyPublisher<Data, ImageCacheError>
}

struct DefaultRetriveCachedImageUseCase: RetriveCachedImageUseCase {
    @Inject private var cacheRepository: CacheRepository
    
    public init() { }
    
    func execute(url: String) -> AnyPublisher<Data, ImageCacheError> {
        cacheRepository.getImage(url: url)
    }
}
