//
//  ShippingAdressesViewModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 30.01.25.
//

import Foundation
import Combine

protocol ShippingAddressesViewModel: ShippingAddressesViewModelInput, ShippingAddressesViewModelOutput {
}

protocol ShippingAddressesViewModelInput {
    func fetchAddresses()
    func addAddress(_ address: AddressModel)
    func removeAddress(_ address: AddressModel)
    func setDefaultAddress(_ address: AddressModel)
}

protocol ShippingAddressesViewModelOutput {
    var output: AnyPublisher<ShippingAddressesViewModelOutputAction, Never> { get }
}

enum ShippingAddressesViewModelOutputAction {
    case shippingAddressesFetched([AddressModel])
    case shippingAddressAdded(AddressModel)
    case shippingAddressRemoved(AddressModel)
    case newDefaultAddress(AddressModel)
    case error(Error)
}

final class DefaultShippingAddressesViewModel: ObservableObject, ShippingAddressesViewModel {
    @Inject private var deliveryRepository: DeliveryRepository
    private var cancellables = Set<AnyCancellable>()
    
    private let outputSubject = PassthroughSubject<ShippingAddressesViewModelOutputAction, Never>()
    
    var output: AnyPublisher<ShippingAddressesViewModelOutputAction, Never> {
        outputSubject.eraseToAnyPublisher()
    }
    
    init() { }
    
    func fetchAddresses() {
        deliveryRepository.fetchAddresses()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.outputSubject.send(.error(error))
                }
            }, receiveValue: { [weak self] addresses in
                self?.outputSubject.send(.shippingAddressesFetched(addresses.sorted(by: { $0.isDefault && !$1.isDefault})))
            })
            .store(in: &cancellables)
    }
    
    func addAddress(_ address: AddressModel) {
        deliveryRepository.addAddress(address: address)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.outputSubject.send(.error(error))
                }
            }, receiveValue: { [weak self] _ in
                self?.outputSubject.send(.shippingAddressAdded(address))
                self?.fetchAddresses()
            })
            .store(in: &cancellables)
    }
    
    func removeAddress(_ address: AddressModel) {
        let addressId = address.id
        
        deliveryRepository.removeAddress(id: addressId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.outputSubject.send(.error(error))
                }
            }, receiveValue: { [weak self] _ in
                self?.outputSubject.send(.shippingAddressRemoved(address))
                self?.fetchAddresses()
            })
            .store(in: &cancellables)
    }
    
    func setDefaultAddress(_ address: AddressModel) {
        let addressId = address.id
        
        deliveryRepository.updateDefaultAddress(id: addressId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.outputSubject.send(.error(error))
                }
            }, receiveValue: { [weak self] _ in
                self?.outputSubject.send(.newDefaultAddress(address))
                self?.fetchAddresses()
            })
            .store(in: &cancellables)
    }
}
