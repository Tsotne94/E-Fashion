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
    var fetchedOrdersStatus: OrderStatus { get }
    var orders: [OrderModel] { get }
}

protocol OrderHistoryViewModelOutput {
    var output: AnyPublisher<OrderHistoryViewModelAutputAction, Never> { get }
}

enum OrderHistoryViewModelAutputAction {
    case ordersFetched
    case statusChanged(OrderStatus)
}

final class DefaultOrderHistoryViewModel: OrderHistoryViewModel {
    @Inject private var profileCorrdinator: ProfileTabCoordinator
    @Inject private var fetchOrdersUseCase: FetchOrdersUseCase
    
    var fetchedOrdersStatus: OrderStatus = .delivered {
        didSet {
            _output.send(.statusChanged(fetchedOrdersStatus))
            fetchOrders(orderType: fetchedOrdersStatus)
        }
    }
    
    var orders: [OrderModel] = []
    
    private var _output = PassthroughSubject<OrderHistoryViewModelAutputAction, Never>()
    var output: AnyPublisher<OrderHistoryViewModelAutputAction, Never> {
        _output.eraseToAnyPublisher()
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    public init() { }
    
    func viewDidLoad() {
        fetchOrders(orderType: fetchedOrdersStatus)
    }
    
    func fetchOrders(orderType: OrderStatus) {
        fetchOrdersUseCase.execute(orderStatus: orderType)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("successfully fetched orders")
                case .failure(let error):
                    print("error occured during orders fetching: \(error)")
                }
            } receiveValue: { [weak self] orders in
                self?.orders = orders
                self?._output.send(.ordersFetched)
            }.store(in: &subscriptions)
    }
    
    func goToOrderDetils(id: String) {
        
    }
}
