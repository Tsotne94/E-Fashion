//
//  DefaultFirestoreFavouritesRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 26.01.25.
//

import Combine
import FirebaseFirestore

final class DefaultFirestoreFavouritesRepository: FirestoreFavouritesRepository {
    @Inject private var getCurrentUserUseCase: GetCurrentUserUseCase
    
    private let db = Firestore.firestore()
    
    public init() { }
    
    func addItemToFavourites(product: ProductDetails) -> AnyPublisher<Void, any Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future { promise in
                    let favouritesRef = Firestore.firestore()
                        .collection("Favourites")
                        .document(user.uid)
                        .collection("items")
                        .document("\(product.productId)")
                    
                    do {
                        try favouritesRef.setData(from: product) { error in
                            if let error = error {
                                promise(.failure(error))
                            } else {
                                promise(.success(()))
                            }
                        }
                    } catch {
                        promise(.failure(error))
                    }
                }
            }.eraseToAnyPublisher()
    }
    
    func fetchFavourites() -> AnyPublisher<[ProductDetails], any Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user -> AnyPublisher<[ProductDetails], Error> in
                Future<[ProductDetails], Error> { promise in
                    let favouritesRef = Firestore.firestore()
                        .collection("Favourites")
                        .document(user.uid)
                        .collection("items")
                    
                    let listener = favouritesRef.addSnapshotListener { snapshot, error in
                        if let error = error {
                            promise(.failure(error))
                            return
                        }
                        
                        let favourites = snapshot?.documents.compactMap { doc -> ProductDetails? in
                            try? doc.data(as: ProductDetails.self)
                        } ?? []
                        
                        promise(.success(favourites))
                    }
                }
                .eraseToAnyPublisher()
            }
            .catch { error in
                Just([]).setFailureType(to: Error.self)
            }
            .eraseToAnyPublisher()
    }
    
    func removeFromFavourites(id: String) -> AnyPublisher<Void, Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future<Void, Error> { promise in
                    let productRef = Firestore.firestore()
                        .collection("Favourites")
                        .document(user.uid)
                        .collection("items")
                        .document(id)
                    
                    productRef.delete { error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
