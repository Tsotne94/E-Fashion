//
//  GetCurrentUserUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//
import Foundation

public protocol GetCurrentUserUseCase {
    func execute() -> User?
}

public struct DefaultGetCurrentUserUseCase: GetCurrentUserUseCase {
    @Inject private var authenticationRepository: AuthenticationRepository
    
    public init() { }
    
    public func execute() -> User? {
        authenticationRepository.getCurrentUser()
    }
}
