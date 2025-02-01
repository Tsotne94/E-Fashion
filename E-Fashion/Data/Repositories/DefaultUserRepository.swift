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
    
    func saveUser(user: User) -> AnyPublisher<Void, Error> {
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
    
    func FetchUserInfoUseCase() -> AnyPublisher<User, Error> {
        getCurrentUser()
            .flatMap { user in
                Future { promise in
                    let userRef = self.db
                        .collection("Users")
                        .document(user.uid)
                    
                    userRef.getDocument { (snapshot, error) in
                        if let error = error {
                            promise(.failure(error))
                            return
                        }
                        
                        guard let snapshot = snapshot, snapshot.exists else {
                            promise(.failure(NSError(domain: "Firestore Error", code: -1, userInfo: [NSLocalizedDescriptionKey: "User document not found"])))
                            return
                        }
                        
                        do {
                            let user = try snapshot.data(as: User.self)
                            promise(.success(user))
                        } catch {
                            promise(.failure(error))
                        }
                    }
                }
            }.eraseToAnyPublisher()
    }
    
    func updateUserInfo(user: User) -> AnyPublisher<Void, Error> {
        getCurrentUser()
            .flatMap { firebaseUser in
                Future { promise in
                    let userRef = db
                        .collection("Users")
                        .document(firebaseUser.uid)
                    
                    do {
                        try userRef.setData(from: user) { error in
                            if let error = error {
                                promise(.failure(error))
                            } else {
                                promise(.success(()))
                            }
                        }
                        
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
    }
}
