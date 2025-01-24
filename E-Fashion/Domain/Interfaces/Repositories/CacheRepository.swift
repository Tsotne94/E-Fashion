//
//  CashRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 22.01.25.
//
import Foundation
import Combine

protocol CacheRepository {
    func cacheImage(url: String, image: Data) -> AnyPublisher<Void, Error>
    func getImage(url: String) -> AnyPublisher<Data, ImageCacheError>
    func clearCache()
    func removeImage(url: String)
}
