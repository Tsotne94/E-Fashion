
//
//  SaveUserUseCase.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 19.01.25.
//
import Combine

public protocol SaveUserUseCase {
    func execute(user: User) -> AnyPublisher<Void, Error>
}

public struct DefaultSaveUserUseCase: SaveUserUseCase {
    @Inject private var userRepository: UserRepository
    
    public init() { }
    
    public func execute(user: User) -> AnyPublisher<Void, any Error> {
        userRepository.saveUser(user: user)
    }
}
