//
//  DefaultUserRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 19.01.25.
//
import Combine
import FirebaseAuth
import FirebaseFirestore

public struct DefaultUserRepository: UserRepository {
    private let db = Firestore.firestore()
    public init() { }
    
    func getCurrentUser() -> AnyPublisher<User, Error> {
        Future { promise in
            if let user = Auth.auth().currentUser {
                promise(.success(UserDTO(from: user).toUser()))
            } else {
                promise(.failure(NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error Occured During Registration, Please Try Again"])))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func saveUser(user: User) -> AnyPublisher<Void, any Error> {
        let userDTO = UserDTO(from: user)
        return Future { promise in
            db.collection("Users").addDocument(data: userDTO.toDictionary()) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
