//
//  FetchDeliveryAddressUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import Combine

public protocol FetchDeliveryAddressUseCase {
    func execute() -> AnyPublisher<[AddressModel], Error>
}

public struct DefaultFetchDeliveryAddressUseCase: FetchDeliveryAddressUseCase {
    @Inject private var addressRepository: DeliveryRepository
    
    public init() { }
    
    public func execute() -> AnyPublisher<[AddressModel], any Error> {
        addressRepository.fetchAddresses()
    }
}
