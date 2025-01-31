//
//  CheckoutViewModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import Combine
import Foundation

protocol CheckoutViewModel: CheckoutViewModelInput, CheckoutViewModelOutput {
}

protocol CheckoutViewModelInput {
    func fetchDefaultAddress()
    func fetchDefaultPayment()
    func goBack()
    func changeDeliveryLocation()
    func changeCard()
    func orderPlaced()
    var products: [ProductInCart] { get }
    var totalPrice: Double? { get }
    var defaultDeliveryLocation: AddressModel? { get }
    var defaultPaymentMethod: CardModel? { get }
}

protocol CheckoutViewModelOutput {
    
}

enum CheckoutViewModelOutputAction {
    
}

final class DefaultCheckoutViewModel: ObservableObject, CheckoutViewModel {
    @Inject private var coordinator: BagTabCoordinator
    
    @Inject private var fetchProductsInCartUseCase: FetchItemsInCartUseCase
    @Inject private var fetchDefaultPaymentUseCase: FetchDefaultPaymentMethodUseCase
    @Inject private var fetchDefaultAddressUseCase: FetchDefaultDelieryLocationUseCase
    
    @Published var products: [ProductInCart] = []
    @Published var totalPrice: Double? = nil
    @Published var defaultDeliveryLocation: AddressModel? = nil
    @Published var defaultPaymentMethod: CardModel? = nil
    
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        fetchProducts()
        fetchDefaultAddress()
        fetchDefaultPayment()
    }
    
    func goBack() {
        coordinator.goBack()
    }
    
    func changeDeliveryLocation() {
        coordinator.changeDeliveryLocation()
    }
    
    func changeCard() {
        coordinator.changeCard()
    }
    
    func orderPlaced() {
        coordinator.orderPlaced()
    }
    
    func fetchDefaultAddress() {
        fetchDefaultAddressUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("successfully fetched default delivery loation")
                case .failure(let error):
                    print("failed to fetch default delivery location error: \(error)")
                }
            } receiveValue: { [weak self] address in
                self?.defaultDeliveryLocation = address
            }.store(in: &subscriptions)

    }
    
    func fetchDefaultPayment() {
        fetchDefaultPaymentUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("successfully fetched default payment method")
                case .failure(let error):
                    print("failed to fetch default payment method error: \(error)")
                }
            } receiveValue: { [weak self] method in
                self?.defaultPaymentMethod = method
            }.store(in: &subscriptions)
    }
    
    func fetchProducts() {
        fetchProductsInCartUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] products in
                self?.products = products
                self?.totalPrice = products.reduce(into: 0) { partialResult, product in
                    partialResult += product.product.price.totalAmount.asNumber()
                }
            }
            .store(in: &subscriptions)
    }
    
    func isVlaid() -> Bool {
        products.isEmpty || defaultPaymentMethod == nil || defaultDeliveryLocation == nil
    }
}
