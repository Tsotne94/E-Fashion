//
//  DefaultFirestoreFavouritesRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 26.01.25.
//

import Foundation
import Combine
import FirebaseFirestore

struct DefaultFirestoreFavouritesRepository: FirestoreFavouritesRepository {
    @Inject private var getCurrentUserUseCase: GetCurrentUserUseCase
    private let db = Firestore.firestore()
    
    public init() { }
    
    public func addItemToFavourites(product: Product) -> AnyPublisher<Void, any Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future { promise in
                    let favourite = FavouriteProduct(id: "\(product.productId)", product: product)
                    let favouritesRef = db
                        .collection("Favourites")
                        .document(user.uid)
                        .collection("items")
                        .document(favourite.id)
                    
                    do {
                        try favouritesRef.setData(from: favourite) { error in
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
    
    public func fetchFavourites() -> AnyPublisher<[Product], any Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user -> AnyPublisher<[Product], Error> in
                Future<[Product], Error> { promise in
                    let favouritesRef = db
                        .collection("Favourites")
                        .document(user.uid)
                        .collection("items")
                        .order(by: "timestamp", descending: true)
                    
                    favouritesRef.getDocuments { snapshot, error in
                        if let error = error {
                            promise(.failure(error))
                            return
                        }
                        
                        let favourites = snapshot?.documents.compactMap { doc -> Product? in
                            guard let favouriteProduct = try? doc.data(as: FavouriteProduct.self) else {
                                return nil
                            }
                            return favouriteProduct.product
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
    
    public func removeFromFavourites(id: String) -> AnyPublisher<Void, Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future<Void, Error> { promise in
                    let productRef = db
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
    
    public func isFavourite(id: String) -> AnyPublisher<Bool, Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future<Bool, Error> { promise in
                    let favouritesRef = db
                        .collection("Favourites")
                        .document(user.uid)
                        .collection("items")
                        .document(id)
                    
                    favouritesRef.getDocument { snapshot, error in
                        if let error = error {
                            promise(.failure(error))
                            return
                        }
                        
                        promise(.success(snapshot?.exists ?? false))
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
