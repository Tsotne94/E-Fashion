//
//  FetchOrdersUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 16.02.25.
//

import Combine

public protocol FetchOrdersUseCase {
    func execute(orderStatus: OrderStatus) -> AnyPublisher<[OrderModel], Error>
}

public struct DefaultFetchOrdersUseCase: FetchOrdersUseCase {
    @Inject private var orderRepository: OrdersRepository
    
    public init() { }
    
    public func execute(orderStatus: OrderStatus) -> AnyPublisher<[OrderModel], any Error> {
        orderRepository.fetchOrders(orderStatus: orderStatus)
    }
}
