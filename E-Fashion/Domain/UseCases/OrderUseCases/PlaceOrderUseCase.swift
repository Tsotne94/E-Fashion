//
//  PlaceOrderUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 16.02.25.
//

import Combine

public protocol PlaceOrderUseCase {
    func execute(order: OrderModel) -> AnyPublisher<Void, Error>
}

public struct DefaultPlaceOrderUseCase: PlaceOrderUseCase {
    @Inject private var orderRepository: OrdersRepository
    
    public init() { }
    
    public func execute(order: OrderModel) -> AnyPublisher<Void, Error> {
        orderRepository.placeOrder(order: order)
    }
}
