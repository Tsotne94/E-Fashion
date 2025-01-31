//
//  PaymentRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 31.01.25.
//

import Combine

protocol PaymentRepository {
    func addPaymentMethod(method: CardModel) -> AnyPublisher<Void, Error>
    func fetchPaymentMethods() -> AnyPublisher<[CardModel], Error>
    func removePaymentMethod(id: String) -> AnyPublisher<Void, Error>
    func updateDefaultPaymentMethod(id: String) -> AnyPublisher<Void, Error>
}
