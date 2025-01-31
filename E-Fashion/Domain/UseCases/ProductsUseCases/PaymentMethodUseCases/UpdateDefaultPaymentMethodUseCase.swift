//
//  UpdateDefaultPaymentMethodUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import Combine

protocol UpdateDefaultPaymentMethodUseCase {
    func execute(id: String) -> AnyPublisher<Void, Error>
}

public struct DefaultUpdateDefaultPaymentMethodUseCase: UpdateDefaultPaymentMethodUseCase {
    @Inject private var paymentRepository: PaymentRepository
    
    public init() { }
    
    func execute(id: String) -> AnyPublisher<Void, any Error> {
        paymentRepository.updateDefaultPaymentMethod(id: id)
    }
}
