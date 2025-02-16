//
//  OrdersRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 16.02.25.
//

import Combine

public protocol OrdersRepository {
    func placeOrder(order: OrderModel) -> AnyPublisher<Void, Error>
    func fetchOrders(orderStatus: OrderStatus) -> AnyPublisher<[OrderModel], Error>
    func fetchSingleOrder(id: String) -> AnyPublisher<OrderModel, Error>
}
