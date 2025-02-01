//
//  UpdateUserInfoUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 01.02.25.
//

import Combine

protocol UpdateUserInfoUseCase {
    func execute(user: User) -> AnyPublisher<Void, Error>
}

public struct DefaultUpdateUserInfoUseCase: UpdateUserInfoUseCase {
    @Inject private var userRepository: UserRepository
    
    public init() { }
    
    func execute(user: User) -> AnyPublisher<Void, any Error> {
        userRepository.updateUserInfo(user: user)
    }
}
