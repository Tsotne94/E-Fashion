//
//  DefaultFirestoreCartRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 26.01.25.
//

import Combine
import FirebaseFirestore

public struct DefaultFirestoreCartRepository: FirestoreCartRepository {
    @Inject private var getCurrentUserUseCase: GetCurrentUserUseCase
    
    public init() { }
    
    public func addToCart(product: ProductInCart) -> AnyPublisher<Void, any Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future { promise in
                    let cartRef = Firestore.firestore()
                        .collection("Carts")
                        .document(user.uid)
                        .collection("items")
                        .document(product.id)
                    do {
                        try cartRef.setData(from: product) { error in
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
            }
            .eraseToAnyPublisher()
    }
    
    public func fetchItemsInCart() -> AnyPublisher<[ProductInCart], Never> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future<[ProductInCart], Error> { promise in
                    let cartRef = Firestore.firestore()
                        .collection("Carts")
                        .document(user.uid)
                        .collection("items")
                        .order(by: "timestamp", descending: true)
                    
                    cartRef.getDocuments { snapshot, error in
                        guard let snapshot = snapshot else {
                            promise(.success([]))
                            return
                        }
                        
                        let items = snapshot.documents.compactMap { doc -> ProductInCart? in
                            try? doc.data(as: ProductInCart.self)
                        }
                        
                        promise(.success(items))
                    }
                }
            }
            .catch { _ in Just([]) }
            .eraseToAnyPublisher()
    }
    
    public func removeWholeItem(id: String) -> AnyPublisher<Void, any Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future { promise in
                    let cartRef = Firestore.firestore()
                        .collection("Carts")
                        .document(user.uid)
                        .collection("items")
                        .document(id)
                    
                    cartRef.delete { error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func isInCart(id: String) -> AnyPublisher<Bool, any Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future { promise in
                    let cartRef = Firestore.firestore()
                        .collection("Carts")
                        .document(user.uid)
                        .collection("items")
                        .document(id)
                    
                    cartRef.getDocument { (document, error) in
                        if let error = error {
                            promise(.failure(error))
                            return
                        }
                        
                        let exists = document?.exists ?? false
                        promise(.success(exists))
                    }
                }
            }.eraseToAnyPublisher()
    }
    
    public func clearItems() -> AnyPublisher<Void, Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user -> AnyPublisher<Void, Error> in
                let cartRef = Firestore.firestore()
                    .collection("Carts")
                    .document(user.uid)
                    .collection("items")
                
                return Future { promise in
                    cartRef.getDocuments { snapshot, error in
                        if let error = error {
                            promise(.failure(error))
                            return
                        }
                        
                        guard let docs = snapshot?.documents, !docs.isEmpty else {
                            promise(.success(()))
                            return
                        }
                        
                        let batch = Firestore.firestore().batch()
                        docs.forEach { doc in
                            batch.deleteDocument(cartRef.document(doc.documentID))
                        }
                        
                        batch.commit { error in
                            if let error = error {
                                promise(.failure(error))
                            } else {
                                promise(.success(()))
                            }
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
