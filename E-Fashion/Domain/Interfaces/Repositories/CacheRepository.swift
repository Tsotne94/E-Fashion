//
//  CashRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 22.01.25.
//
import Foundation
import Combine

protocol CacheRepository {
    func cashImage(id: String, image: Data) -> AnyPublisher<Void, Error>
    func getImage(id: String) -> AnyPublisher<Data, ImageCacheError>
    func clearCash()
    func removeimage(id: String)
}
