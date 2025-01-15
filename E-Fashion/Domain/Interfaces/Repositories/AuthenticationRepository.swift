//
//  AuthenticationRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//
import Combine

protocol AuthenticationRepository {
    func signIn(email: String, password: String) -> AnyPublisher<User, Never>
    func signUp(email: String, password: String) -> AnyPublisher<User, Never>
    func signOut() -> AnyPublisher<Void, Never>
    func getCurrentUser() -> User?
}
