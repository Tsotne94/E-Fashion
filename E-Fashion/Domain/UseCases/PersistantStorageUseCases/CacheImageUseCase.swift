//
//  CashImageUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 22.01.25.
//

import Foundation
import Combine

public protocol CacheImageUseCase {
    func execute(url: String, imageAsData: Data) -> AnyPublisher<Void, Error>
}

public struct DefaultCacheImageUseCase: CacheImageUseCase {
    @Inject private var cacheRepository: CacheRepository
    
    public init() { }
    
    public func execute(url: String, imageAsData: Data) -> AnyPublisher<Void, any Error> {
        cacheRepository.cacheImage(url: url, image: imageAsData)
    }
}
