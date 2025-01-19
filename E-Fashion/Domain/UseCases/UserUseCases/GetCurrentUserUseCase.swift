//
//  GetCurrentUserUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//
import Foundation
import Combine

public protocol GetCurrentUserUseCase {
    func execute() -> AnyPublisher<User, Error>
}

public struct DefaultGetCurrentUserUseCase: GetCurrentUserUseCase {
    @Inject private var userRepository: UserRepository
    
    public init() { }
    
    public func execute() -> AnyPublisher<User, Error> {
        userRepository.getCurrentUser()
    }
}
