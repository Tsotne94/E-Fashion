//
//  FetchDefaultDelieryLocationUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import Combine

public protocol FetchDefaultDelieryLocationUseCase {
    func execute() -> AnyPublisher<AddressModel, Error>
}

public struct DefaultFetchDefaultDelieryLocationUseCase: FetchDefaultDelieryLocationUseCase {
    @Inject private var deliveryRepository: DeliveryRepository
    
    public init() { }
    
    public func execute() -> AnyPublisher<AddressModel, any Error> {
        deliveryRepository.fetchDefaultDelieryLocation()
    }
}
