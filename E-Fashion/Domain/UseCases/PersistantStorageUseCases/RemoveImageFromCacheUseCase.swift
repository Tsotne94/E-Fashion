//
//  RemoveImageFromCacheUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 22.01.25.
//
import Foundation

protocol RemoveImageFromCacheUseCase {
    func execute(id: String)
}

struct DefaultRemoveImageFromCacheUseCase: RemoveImageFromCacheUseCase {
    @Inject private var cacheRepository: CacheRepository
    
    public init() { }
    
    func execute(id: String) {
        cacheRepository.removeimage(id: id)
    }
}
