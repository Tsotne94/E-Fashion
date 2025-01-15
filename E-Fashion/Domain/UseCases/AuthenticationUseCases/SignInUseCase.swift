//
//  SignInUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//
import Combine

public protocol SignInUseCase {
    func execute(email: String, password: String) -> AnyPublisher<User, Never>
}

public struct DefaultSignInUseCase: SignInUseCase {
    @Inject private var authenticationRepository: AuthenticationRepository
    
    public init() { }
    
    public func execute(email: String, password: String) -> AnyPublisher<User, Never> {
        authenticationRepository.signIn(email: email, password: password)
    }
}
