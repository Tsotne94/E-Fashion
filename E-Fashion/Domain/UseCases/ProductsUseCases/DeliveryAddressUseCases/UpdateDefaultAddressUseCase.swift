//
//  UpdateDefaultAddressUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import Combine

public protocol UpdateDefaultAddressUseCase {
    func execute(id: String) -> AnyPublisher<Void, Error>
}

public struct DefaultUpdateDefaultAddressUseCase: UpdateDefaultAddressUseCase {
    @Inject private var addressRepository: DeliveryRepository
    
    public init() { }
    
    public func execute(id: String) -> AnyPublisher<Void, any Error> {
        addressRepository.updateDefaultAddress(id: id)
    }
}
