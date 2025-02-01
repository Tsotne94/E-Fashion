//
//  FetchUserInfoUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 01.02.25.
//

import Combine

protocol FetchUserInfoUseCase {
    func execute() -> AnyPublisher<User, Error>
}

public struct DefaultFetchUserInfoUseCase: FetchUserInfoUseCase {
    @Inject private var userRepository: UserRepository
    
    public init() { }
    
    func execute() -> AnyPublisher<User, any Error> {
        userRepository.FetchUserInfoUseCase()
    }
}
