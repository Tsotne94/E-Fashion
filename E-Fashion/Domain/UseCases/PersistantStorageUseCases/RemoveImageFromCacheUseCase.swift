//
//  RemoveImageFromCacheUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 22.01.25.
//

public protocol RemoveImageFromCacheUseCase {
    func execute(url: String)
}

public struct DefaultRemoveImageFromCacheUseCase: RemoveImageFromCacheUseCase {
    @Inject private var cacheRepository: CacheRepository
    
    public init() { }
    
    public func execute(url: String) {
        cacheRepository.removeImage(url: url)
    }
}
