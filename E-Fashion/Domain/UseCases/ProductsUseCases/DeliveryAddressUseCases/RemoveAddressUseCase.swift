//
//  RemoveAddressUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import Combine

public protocol RemoveAddressUseCase {
    func execute(id: String) -> AnyPublisher<Void, Error>
}

public struct DefaultRemoveAddressUseCase: RemoveAddressUseCase {
    @Inject private var addressRepository: DeliveryRepository
    
    public init() { }
    
    public func execute(id: String) -> AnyPublisher<Void, Error> {
        addressRepository.removeAddress(id: id)
    }
}
