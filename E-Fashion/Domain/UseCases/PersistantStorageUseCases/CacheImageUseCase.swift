//
//  CashImageUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 22.01.25.
//
import Foundation
import Combine

protocol CacheImageUseCase {
    func execute(id: String, imageAsData: Data) -> AnyPublisher<Void, Error>
}

struct DefaultCacheImageUseCase: CacheImageUseCase {
    @Inject private var cacheRepository: CacheRepository
    
    public init() { }
    
    func execute(id: String, imageAsData: Data) -> AnyPublisher<Void, any Error> {
        cacheRepository.cashImage(id: id, image: imageAsData)
    }
}
