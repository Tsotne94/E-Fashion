//
//  ClearCacheUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 22.01.25.
//
import Foundation

protocol ClearCacheUseCase {
    func execute()
}

struct DefaultClearCacheUseCase: ClearCacheUseCase {
    @Inject private var cacheRepository: CacheRepository
    
    public init() { }
    
    func execute() {
        cacheRepository.clearCache()
    }
}
