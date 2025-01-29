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
    private var favouritesListener: ListenerRegistration?
    
    private let db = Firestore.firestore()
    
    public init() { }
    
    func addItemToFavourites(product: Product) -> AnyPublisher<Void, any Error> {
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
    
    func fetchFavourites() -> AnyPublisher<[Product], any Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user -> AnyPublisher<[Product], Error> in
                Future<[Product], Error> { [weak self] promise in
                    guard let self = self else { return }
                    
                    self.favouritesListener?.remove()
                    
                    let favouritesRef = Firestore.firestore()
                        .collection("Favourites")
                        .document(user.uid)
                        .collection("items")
                    
                    self.favouritesListener = favouritesRef.addSnapshotListener { snapshot, error in
                        if let error = error {
                            promise(.failure(error))
                            return
                        }
                        
                        let favourites = snapshot?.documents.compactMap { doc -> Product? in
                            try? doc.data(as: Product.self)
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
    
    func isFavourite(id: String) -> AnyPublisher<Bool, Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future<Bool, Error> { promise in
                    let favouritesRef = Firestore.firestore()
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
    
    deinit {
        favouritesListener?.remove()
    }
}
