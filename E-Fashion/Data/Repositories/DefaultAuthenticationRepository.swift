//
//  DefaultAuthenticationRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//

import Foundation
import Combine
import FirebaseAuth

public struct DefaultAuthenticationRepository: AuthenticationRepository {
    
    public init() { }
    
    public func signIn(email: String, password: String) -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("Sign-in failed with error: \(error.localizedDescription)")
                    promise(.failure(error))
                } else if let firebaseUser = authResult?.user {
                    let user = UserDTO(from: firebaseUser).toUser()
                    promise(.success(user))
                } else {
                    promise(.success(User()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func signUp(email: String, password: String) -> AnyPublisher<User, Error> {
        Future<User, Error> { promise in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    promise(.failure(error))
                       return
                   }
                   
                   guard let user = result?.user else {
                       promise(.failure(NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No current user found"])))
                       return
                   }
                   
                promise(.success(UserDTO(from: user).toUser()))
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func signOut() -> AnyPublisher<Void, Never> {
        return Future<Void, Never> { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            } catch {
                promise(.failure(error as! Never))
            }
        }
        .eraseToAnyPublisher()
    }
}
