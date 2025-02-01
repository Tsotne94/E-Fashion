//
//  ClearCacheUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 22.01.25.
//

public protocol ClearCacheUseCase {
    func execute()
}

public struct DefaultClearCacheUseCase: ClearCacheUseCase {
    @Inject private var cacheRepository: CacheRepository
    
    public init() { }
    
    public func execute() {
        cacheRepository.clearCache()
    }
}
