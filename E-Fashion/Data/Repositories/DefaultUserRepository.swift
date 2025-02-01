//
//  DefaultUserRepository.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 19.01.25.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

public struct DefaultUserRepository: UserRepository {
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    public init() { }
    
    public func getCurrentUser() -> AnyPublisher<User, Error> {
        Future { promise in
            if let user = Auth.auth().currentUser {
                promise(.success(UserDTO(from: user).toUser()))
            } else {
                promise(.failure(NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found"])))
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func saveUser(user: User) -> AnyPublisher<Void, Error> {
        guard let firebaseUser = Auth.auth().currentUser else {
            return Fail(error: NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found"]))
                .eraseToAnyPublisher()
        }
        
        let userDTO = UserDTO(from: user)
        return Future { promise in
            self.db.collection("Users")
                .document(firebaseUser.uid)
                .setData(userDTO.toDictionary()) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    public func FetchUserInfoUseCase() -> AnyPublisher<User, Error> {
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
    
    public func updateUserInfo(user: User) -> AnyPublisher<Void, Error> {
        getCurrentUser()
            .flatMap { firebaseUser in
                Future { promise in
                    let userRef = db
                        .collection("Users")
                        .document(firebaseUser.uid)
                    
                    do {
                        try userRef.setData(from: user, merge: true) { error in
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
    
    public func uploadProfilePicture(image: Data) -> AnyPublisher<Void, Error> {
        getCurrentUser()
            .flatMap { user in
                let id = user.uid
                let fileName = "\(id).jpg"
                return self.uploadImageToStorage(image: image, fileName: fileName)
                    .flatMap { downloadURL in
                        self.updateImageURL(downloadURL, for: id)
                    }
            }
            .eraseToAnyPublisher()
    }

    public func uploadImageToStorage(image: Data, fileName: String) -> AnyPublisher<String, Error> {
        let storageRef = storage.reference().child("profile_images/\(fileName)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        return Future { promise in
            storageRef.putData(image, metadata: metadata) { _, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                storageRef.downloadURL { url, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let url = url {
                        promise(.success(url.absoluteString))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

    public func updateImageURL(_ url: String, for userID: String) -> AnyPublisher<Void, Error> {
        let userRef = db.collection("Users").document(userID)
        return Future { promise in
            userRef.updateData(["imageUrl": url]) { error in
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
