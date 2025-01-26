//
//  DefaultFirestoreFavouritesRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 26.01.25.
//
import Combine
import FirebaseFirestore

final class DefaultFirestoreFavouritesRepository: FirestoreFavouritesRepository {
    private let db = Firestore.firestore()
    
    public init() { }
    
    func addItemToFavourites(product: ProductDetails) -> AnyPublisher<Void, any Error> {
        
    }
    
    func fetchFavourites() -> AnyPublisher<[ProductDetails], any Error> {
        
    }
    
    func removeFromFavourites(id: String) -> AnyPublisher<Void, Never> {
        
        
    }
    
}
