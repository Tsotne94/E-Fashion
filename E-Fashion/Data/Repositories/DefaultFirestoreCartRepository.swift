//
//  DefaultFirestoreCartRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 26.01.25.
//

import Combine
import FirebaseFirestore

final class DefaultFirestoreCartRepository: FirestoreCartRepository {
    @Inject private var getCurrentUserUseCase: GetCurrentUserUseCase
    
    public init() { }
    
    func addToCart(product: ProductInCart) -> AnyPublisher<Void, any Error> {
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
    
    func fetchItemsInCart() -> AnyPublisher<[ProductInCart], Never> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future<[ProductInCart], Error> { promise in
                    let cartRef = Firestore.firestore()
                        .collection("Carts")
                        .document(user.uid)
                        .collection("items")
                    
                    _ = cartRef.addSnapshotListener { snapshot, error in
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
    
    func removeOneItemFromCart(id: String) -> AnyPublisher<Void, any Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future { promise in
                    let cartRef = Firestore.firestore()
                        .collection("Carts")
                        .document(user.uid)
                        .collection("items")
                        .document(id)
                    
                    cartRef.updateData(["quantity": FieldValue.increment(-1.0)]) { error in
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
    
    func removeWholeItem(id: String) -> AnyPublisher<Void, any Error> {
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
}
