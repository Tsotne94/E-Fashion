//
//  DefaultCashRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 22.01.25.
//
import Combine
import Foundation

public struct DefaultCashRepository: CacheRepository {
    private let cache: NSCache<NSString, NSData>
    
    public init() {
        self.cache = NSCache<NSString, NSData>()
        self.cache.name = "ImageCache"
        
    }
    
    func cashImage(id: String, image: Data) -> AnyPublisher<Void, any Error> {
        Just(())
            .tryMap { _ in
                self.cache.setObject(image as NSData, forKey: id as NSString)
            }
            .mapError { _ in
                ImageCacheError.saveFailed
            }
            .eraseToAnyPublisher()
    }
    
    func getImage(id: String) -> AnyPublisher<Data, ImageCacheError> {
        Just(id)
            .tryMap { id -> Data in
                guard let data = self.cache.object(forKey: id as NSString) as Data? else {
                    throw ImageCacheError.notFound
                }
                return data
            }
            .mapError { error -> ImageCacheError in
                if let cacheError = error as? ImageCacheError {
                    return cacheError
                }
                return .notFound
            }
            .eraseToAnyPublisher()
    }
    
    func clearCash() {
        cache.removeAllObjects()
    }
    
    func removeimage(id: String) {
        cache.removeObject(forKey: id as NSString)
    }
}




