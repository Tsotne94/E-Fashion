//
//  RetriveCashedImageUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 22.01.25.
//
import Foundation
import Combine

protocol RetriveCachedImageUseCase {
    func execute(id: String) -> AnyPublisher<Data, ImageCacheError>
}

struct DefaultRetriveCachedImageUseCase: RetriveCachedImageUseCase {
    @Inject private var cacheRepository: CacheRepository
    
    public init() { }
    
    func execute(id: String) -> AnyPublisher<Data, ImageCacheError> {
        cacheRepository.getImage(id: id)
    }
}
