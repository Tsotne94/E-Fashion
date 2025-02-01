//
//  UserRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 19.01.25.
//

import Foundation
import Combine

protocol UserRepository {
    func getCurrentUser() -> AnyPublisher<User, Error>
    func saveUser(user: User) -> AnyPublisher<Void, Error>
    func FetchUserInfoUseCase() -> AnyPublisher<User, Error>
    func updateUserInfo(user: User) -> AnyPublisher<Void, Error>
    func uploadProfilePicture(image: Data) -> AnyPublisher<Void, Error>
}
