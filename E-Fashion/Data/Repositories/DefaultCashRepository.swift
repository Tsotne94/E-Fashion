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
    
    func cacheImage(url: String, image: Data) -> AnyPublisher<Void, any Error> {
        Just(())
            .tryMap { _ in
                self.cache.setObject(image as NSData, forKey: url as NSString)
                print("cahsed for url: " + url)
            }
            .mapError { _ in
                ImageCacheError.saveFailed
            }
            .eraseToAnyPublisher()
    }
    
    func getImage(url: String) -> AnyPublisher<Data, ImageCacheError> {
        Just(url)
            .tryMap { url -> Data in
                guard let data = self.cache.object(forKey: url as NSString) as Data? else {
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
    
    func clearCache() {
        cache.removeAllObjects()
    }
    
    func removeImage(url: String) {
        cache.removeObject(forKey: url as NSString)
    }
}




