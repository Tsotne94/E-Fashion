//
//  FetchPaymentMethodsUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import Combine

public protocol FetchPaymentMethodsUseCase {
    func execute() -> AnyPublisher<[CardModel], Error>
}

public struct DefaultFetchPaymentMethodsUseCase: FetchPaymentMethodsUseCase {
    @Inject private var paymentRepository: PaymentRepository
    
    public init() { }
    
    public func execute() -> AnyPublisher<[CardModel], any Error> {
        paymentRepository.fetchPaymentMethods()
    }
}
