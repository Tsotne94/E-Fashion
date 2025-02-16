//
//  RemovePaymentMethodUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import Combine

public protocol RemovePaymentMethodUseCase {
    func execute(id: String) -> AnyPublisher<Void, Error>
}

public struct DefaultRemovePaymentMethodUseCase: RemovePaymentMethodUseCase {
    @Inject private var paymentRepository: PaymentRepository
    
    public init() { }
    
    public func execute(id: String) -> AnyPublisher<Void, any Error> {
        paymentRepository.removePaymentMethod(id: id)
    }
}
