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
    var addresses: [AddressModel] { get }
}

protocol ShippingAddressesViewModelOutput {
    var output: AnyPublisher<ShippingAddressesViewModelOutputAction, Never> { get }
}

enum ShippingAddressesViewModelOutputAction {
    case error(Error)
}

final class DefaultShippingAddressesViewModel: ObservableObject, ShippingAddressesViewModel {
    @Inject private var deliveryRepository: DeliveryRepository
    private var cancellables = Set<AnyCancellable>()
    
    private let _output = PassthroughSubject<ShippingAddressesViewModelOutputAction, Never>()
    
    var output: AnyPublisher<ShippingAddressesViewModelOutputAction, Never> {
        _output.eraseToAnyPublisher()
    }
    
    @Published var addresses: [AddressModel] = [] 
    
    init() { }
    
    func fetchAddresses() {
        deliveryRepository.fetchAddresses()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?._output.send(.error(error))
                }
            }, receiveValue: { [weak self] addresses in
                self?.addresses = addresses.sorted(by: { $0.isDefault && !$1.isDefault})
            })
            .store(in: &cancellables)
    }
    
    func addAddress(_ address: AddressModel) {
        deliveryRepository.addAddress(address: address)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?._output.send(.error(error))
                }
            }, receiveValue: { [weak self] _ in
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
                    self?._output.send(.error(error))
                }
            }, receiveValue: { [weak self] _ in
                self?.fetchAddresses()
            })
            .store(in: &cancellables)
    }
    
    func setDefaultAddress(_ address: AddressModel) {
        guard !address.isDefault else { return }
        
        let addressId = address.id
        
        deliveryRepository.updateDefaultAddress(id: addressId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?._output.send(.error(error))
                }
            }, receiveValue: { [weak self] _ in
                self?.fetchAddresses()
            })
            .store(in: &cancellables)
    }
}
