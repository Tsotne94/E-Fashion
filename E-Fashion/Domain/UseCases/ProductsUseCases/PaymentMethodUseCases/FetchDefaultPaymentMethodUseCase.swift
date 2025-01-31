//
//  FetchDefaultPaymentMethodUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import Combine

protocol FetchDefaultPaymentMethodUseCase {
    func execute() -> AnyPublisher<CardModel, Error>
}

public struct DefaultFetchDefaultPaymentMethodUseCase: FetchDefaultPaymentMethodUseCase {
    @Inject private var paymentRepository: PaymentRepository
    
    public init() { }
    
    func execute() -> AnyPublisher<CardModel, any Error> {
        paymentRepository.fetchDefaultPaymentMethod()
    }
}
