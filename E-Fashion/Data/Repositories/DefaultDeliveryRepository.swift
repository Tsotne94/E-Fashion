//
//  DefaultDeliveryRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import Combine
import FirebaseFirestore

public struct DefaultDeliveryRepository: DeliveryRepository {
    @Inject private var getCurrentUserUseCase: GetCurrentUserUseCase
    
    func addAddress(address: AddressModel) -> AnyPublisher<Void, any Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future { promise in
                    let addressesRef = Firestore.firestore()
                        .collection("Delivery_Locations")
                        .document(user.uid)
                        .collection("locations")
                        .document(address.id)
                    do {
                        try addressesRef.setData(from: address) { error in
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
    
    func removeAddress(id: String) -> AnyPublisher<Void, any Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future { promise in
                    let addressesRef = Firestore.firestore()
                        .collection("Delivery_Locations")
                        .document(user.uid)
                        .collection("locations")
                    
                    addressesRef.document(id).getDocument { document, error in
                        guard let document = document, document.exists else {
                            addressesRef.document(id).delete { error in
                                if let error = error {
                                    promise(.failure(error))
                                } else {
                                    promise(.success(()))
                                }
                            }
                            return
                        }
                        
                        let wasDefault = document.data()?["isDefault"] as? Bool ?? false
                        
                        addressesRef.document(id).delete { error in
                            if let error = error {
                                promise(.failure(error))
                                return
                            }
                            
                            if wasDefault {
                                addressesRef
                                    .order(by: "timestamp", descending: true)
                                    .limit(to: 1)
                                    .getDocuments { snapshot, error in
                                        guard let snapshot = snapshot, !snapshot.documents.isEmpty else {
                                            promise(.success(()))
                                            return
                                        }
                                        
                                        let nextDefaultDoc = snapshot.documents.first!
                                        addressesRef.document(nextDefaultDoc.documentID)
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
    
    func updateDefaultAddress(id: String) -> AnyPublisher<Void, any Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future<Void, any Error> { promise in
                    let addressesRef = Firestore.firestore()
                        .collection("Delivery_Locations")
                        .document(user.uid)
                        .collection("locations")
                    
                    addressesRef.getDocuments { snapshot, error in
                        guard let snapshot = snapshot else {
                            promise(.failure(error ?? NSError(domain: "DeliveryRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch addresses"])))
                            return
                        }
                        
                        let batch = Firestore.firestore().batch()
                        
                        for document in snapshot.documents {
                            let docRef = addressesRef.document(document.documentID)
                            
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
    
    func fetchAddresses() -> AnyPublisher<[AddressModel], any Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future<[AddressModel], any Error> { promise in
                    let addressesRef = Firestore.firestore()
                        .collection("Delivery_Locations")
                        .document(user.uid)
                        .collection("locations")
                        .order(by: "timestamp", descending: true)
                    
                    addressesRef.getDocuments { snapshot, error in
                        if let error = error {
                            promise(.failure(error))
                            return
                        }
                        
                        let items = snapshot?.documents.compactMap { doc in
                            try? doc.data(as: AddressModel.self)
                        } ?? []
                        
                        promise(.success(items))
                    }
                }
            }
            .eraseToAnyPublisher()
    }
}
