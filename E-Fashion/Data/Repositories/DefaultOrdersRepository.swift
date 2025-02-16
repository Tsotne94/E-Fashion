//
//  DefaultOrdersRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 16.02.25.
//

import Combine
import Foundation
import FirebaseFirestore

public struct DefaultOrdersRepository: OrdersRepository {
    @Inject private var getCurrentUserUseCase: GetCurrentUserUseCase
    public init() { }
    
    public func fetchOrders(orderStatus: OrderStatus) -> AnyPublisher<[OrderModel], Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future { promise in
                    let orderRef = Firestore.firestore()
                        .collection("OrdersHistory")
                        .document(user.uid)
                        .collection("Orders")
                        .whereField("status", isEqualTo: orderStatus.rawValue)
                        .order(by: "timeStamp")
                    
                    orderRef.getDocuments { snapshot, error in
                        if let error = error {
                            promise(.failure(error))
                            return
                        }
                        
                        guard let snapshot = snapshot else { promise(.success([])); return }
                        
                        let orders = snapshot.documents.compactMap({ order in
                            try? order.data(as: OrderModel.self)
                        })
                        
                        promise(.success(orders))
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func fetchSingleOrder(id: String) -> AnyPublisher<OrderModel, Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future { promise in
                    
                    let orderRef = Firestore.firestore()
                        .collection("OrdersHistory")
                        .document(user.uid)
                        .collection("Orders")
                        .document(id)
                    
                    orderRef.getDocument { snapshot, error in
                        if let error = error {
                            promise(.failure(error))
                            return
                        }
                        
                        guard let snapshot = snapshot, snapshot.exists else {
                            promise(.failure(NSError(domain: "FirestoreError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Order not found"])))
                            return
                        }
                        
                        do {
                            let order = try snapshot.data(as: OrderModel.self)
                            promise(.success(order))
                        } catch {
                            promise(.failure(error))
                        }
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func placeOrder(order: OrderModel) -> AnyPublisher<Void, Error> {
        getCurrentUserUseCase.execute()
            .flatMap { user in
                Future { promise in
                    let orderRef = Firestore.firestore()
                        .collection("OrdersHistory")
                        .document(user.uid)
                        .collection("Orders")
                        .document(order.id)
                    
                    do {
                        try orderRef.setData(from: order) { error in
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
}
