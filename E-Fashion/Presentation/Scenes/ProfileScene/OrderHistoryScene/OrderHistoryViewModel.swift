//
//  OrderHistoryViewModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 13.02.25.
//

import Combine
import Foundation

protocol OrderHistoryViewModel: OrderHistoryViewModelInput, OrderHistoryViewModelOutput {
}

protocol OrderHistoryViewModelInput {
    func viewDidLoad()
    func fetchOrders(orderType: OrderStatus)
    func goToOrderDetils(id: String)
    var orders: [OrderModel] { get }
}

protocol OrderHistoryViewModelOutput {
    var output: AnyPublisher<OrderHistoryViewModelAutputAction, Never> { get }
}

enum OrderHistoryViewModelAutputAction {
    case ordersFetched
}

final class DefaultOrderHistoryViewModel: OrderHistoryViewModel {
    
    var orders: [OrderModel] = []
    private var _output = PassthroughSubject<OrderHistoryViewModelAutputAction, Never>()
    var output: AnyPublisher<OrderHistoryViewModelAutputAction, Never> {
        _output.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        <#code#>
    }
    
    func fetchOrders(orderType: OrderStatus) {
        <#code#>
    }
    
    func goToOrderDetils(id: String) {
        <#code#>
    }
}
