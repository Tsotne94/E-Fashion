//
//  FetchSingleOrderUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 16.02.25.
//

import Combine

public protocol FetchSingleOrderUseCase {
    func execute(id: String) -> AnyPublisher<OrderModel, Error>
}

public struct DefaultFetchSingleOrderUseCase: FetchSingleOrderUseCase {
    @Inject private var orderRepository: OrdersRepository
    
    public init() { }
    
    public func execute(id: String) -> AnyPublisher<OrderModel, any Error> {
        orderRepository.fetchSingleOrder(id: id)
    }
}
