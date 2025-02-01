//
//  DeliveryRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import Combine

public protocol DeliveryRepository {
    func addAddress(address: AddressModel) -> AnyPublisher<Void, Error>
    func removeAddress(id: String) -> AnyPublisher<Void, Error>
    func updateDefaultAddress(id: String) -> AnyPublisher<Void, Error>
    func fetchAddresses() -> AnyPublisher<[AddressModel], Error>
    func fetchDefaultDelieryLocation() -> AnyPublisher<AddressModel, Error>
}
