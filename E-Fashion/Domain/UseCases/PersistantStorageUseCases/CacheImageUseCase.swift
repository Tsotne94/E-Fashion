//
//  CashImageUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 22.01.25.
//
import Foundation
import Combine

protocol CacheImageUseCase {
    func execute(url: String, imageAsData: Data) -> AnyPublisher<Void, Error>
}

struct DefaultCacheImageUseCase: CacheImageUseCase {
    @Inject private var cacheRepository: CacheRepository
    
    public init() { }
    
    func execute(url: String, imageAsData: Data) -> AnyPublisher<Void, any Error> {
        cacheRepository.cacheImage(url: url, image: imageAsData)
    }
}
