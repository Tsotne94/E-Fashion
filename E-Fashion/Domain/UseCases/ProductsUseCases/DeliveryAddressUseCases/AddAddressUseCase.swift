//
//  AddAddressUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import Combine

public protocol AddAddressUseCase {
    func execute(address: AddressModel) -> AnyPublisher<Void, Error>
}

public struct DefaultAddAddressUseCase: AddAddressUseCase {
    @Inject private var addressRepository: DeliveryRepository
    
    public init() { }
    
    public func execute(address: AddressModel) -> AnyPublisher<Void, any Error> {
        addressRepository.addAddress(address: address)
    }
}
