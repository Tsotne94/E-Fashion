//
//  DefaultPaymentRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import Foundation
import FirebaseFirestore
import Combine

public struct DefaultPaymentRepository: PaymentRepository {
    @Inject private var getCurrentUserUseCase: GetCurrentUserUseCase
    
    public init() { }
    
    public func addPaymentMethod(method: CardModel) -> AnyPublisher<Void, any Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future { promise in
                    let paymentMethodsRef = Firestore.firestore()
                        .collection("Payment_Methods")
                        .document(user.uid)
                        .collection("methods")
                        .document(method.id)
                    
                    do {
                        try paymentMethodsRef.setData(from: method) { error in
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
    
    public func fetchPaymentMethods() -> AnyPublisher<[CardModel], any Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future<[CardModel], any Error> { promise in
                    let paymentMethodsRef = Firestore.firestore()
                        .collection("Payment_Methods")
                        .document(user.uid)
                        .collection("methods")
                        .order(by: "timestamp", descending: true)
                    
                    paymentMethodsRef.getDocuments { snapshot, error in
                        if let error = error {
                            promise(.failure(error))
                            return
                        }
                        
                        let items = snapshot?.documents.compactMap { doc in
                            try? doc.data(as: CardModel.self)
                        } ?? []
                        
                        promise(.success(items))
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func removePaymentMethod(id: String) -> AnyPublisher<Void, any Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future { promise in
                    let paymentMethodsRef = Firestore.firestore()
                        .collection("Payment_Methods")
                        .document(user.uid)
                        .collection("methods")
                    
                    paymentMethodsRef.document(id).getDocument { document, error in
                        guard let document = document, document.exists else {
                            paymentMethodsRef.document(id).delete { error in
                                if let error = error {
                                    promise(.failure(error))
                                } else {
                                    promise(.success(()))
                                }
                            }
                            return
                        }
                        
                        let wasDefault = document.data()?["isDefault"] as? Bool ?? false
                        
                        paymentMethodsRef.document(id).delete { error in
                            if let error = error {
                                promise(.failure(error))
                                return
                            }
                            
                            if wasDefault {
                                paymentMethodsRef
                                    .order(by: "timestamp", descending: true)
                                    .limit(to: 1)
                                    .getDocuments { snapshot, error in
                                        guard let snapshot = snapshot, !snapshot.documents.isEmpty else {
                                            promise(.success(()))
                                            return
                                        }
                                        
                                        let nextDefaultDoc = snapshot.documents.first!
                                        paymentMethodsRef.document(nextDefaultDoc.documentID)
                                            .updateData(["isDefault": true]) { error in
                                                if let error = error {
                                                    promise(.failure(error))
                                                } else {
                                                    promise(.success(()))
                                                }
                                            }
                                    }
                            } else {
                                promise(.success(()))
                            }
                        }
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func updateDefaultPaymentMethod(id: String) -> AnyPublisher<Void, any Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future<Void, any Error> { promise in
                    let paymentMethodsRef = Firestore.firestore()
                        .collection("Payment_Methods")
                        .document(user.uid)
                        .collection("methods")
                    
                    paymentMethodsRef.getDocuments { snapshot, error in
                        guard let snapshot = snapshot else {
                            promise(.failure(error ?? NSError(domain: "PaymentRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch payment methods"])))
                            return
                        }
                        
                        let batch = Firestore.firestore().batch()
                        
                        for document in snapshot.documents {
                            let docRef = paymentMethodsRef.document(document.documentID)
                            
                            if document.documentID == id {
                                batch.updateData(["isDefault": true], forDocument: docRef)
                            } else {
                                batch.updateData(["isDefault": false], forDocument: docRef)
                            }
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
            }
            .eraseToAnyPublisher()
    }
    
    public func fetchDefaultPaymentMethod() -> AnyPublisher<CardModel, any Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future { promise in
                    let paymentMethodsRef = Firestore.firestore()
                        .collection("Payment_Methods")
                        .document(user.uid)
                        .collection("methods")
                        .whereField("isDefault", isEqualTo: true)
                    
                    paymentMethodsRef.getDocuments { snapshot, error in
                        if let error = error {
                            promise(.failure(error))
                            return
                        }
                        
                        guard let documents = snapshot?.documents, !documents.isEmpty else {
                            promise(.failure(URLError(.resourceUnavailable)))
                            return
                        }
                        
                        do {
                            let defaultAddress = try documents.first?.data(as: CardModel.self)
                            
                            if let address = defaultAddress {
                                promise(.success(address))
                            } else {
                                promise(.failure(URLError(.cannotParseResponse)))
                            }
                        } catch {
                            promise(.failure(error))
                        }
                    }
                }
            }.eraseToAnyPublisher()
    }
}
