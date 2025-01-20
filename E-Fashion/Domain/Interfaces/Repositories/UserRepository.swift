//
//  UserRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 19.01.25.
//
import Combine

protocol UserRepository {
    func getCurrentUser() -> AnyPublisher<User, Error>
    func saveUser(user: User) -> AnyPublisher<Void, Error>
}
