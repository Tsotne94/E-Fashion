//
//  AddPaymentMethodUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import Combine

public protocol AddPaymentMethodUseCase {
    func execute(method: CardModel) -> AnyPublisher<Void, Error>
}

public struct DefaultAddPaymentMethodUseCase: AddPaymentMethodUseCase {
    @Inject private var paymentRepository: PaymentRepository
    
    public init() { }
    
    public func execute(method: CardModel) -> AnyPublisher<Void, any Error> {
        paymentRepository.addPaymentMethod(method: method)
    }
}
