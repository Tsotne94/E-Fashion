//
//  RemoveImageFromCacheUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 22.01.25.
//

protocol RemoveImageFromCacheUseCase {
    func execute(url: String)
}

struct DefaultRemoveImageFromCacheUseCase: RemoveImageFromCacheUseCase {
    @Inject private var cacheRepository: CacheRepository
    
    public init() { }
    
    func execute(url: String) {
        cacheRepository.removeImage(url: url)
    }
}
