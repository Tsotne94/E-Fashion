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
    
    
    func signIn(email: String, password: String) -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("Sign-in failed with error: \(error.localizedDescription)")
                    promise(.failure(error))
                } else if let firebaseUser = authResult?.user {
                    let user = User(firebaseUser: firebaseUser)
                    promise(.success(user))
                } else {
                    promise(.success(User()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signUp(email: String, password: String) -> AnyPublisher<User, Error> {
        Future<User, Error> { promise in
            
        }
        .eraseToAnyPublisher()
    }
    
    func signOut() -> AnyPublisher<Void, Never> {
        return Future<Void, Never> { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            } catch {
                promise(.failure(error as! Never))
            }
        }
        .map { _ in () }
        .catch { _ in Just(()) }
        .eraseToAnyPublisher()
    }
    
    func getCurrentUser() -> User? {
        nil
    }
}
