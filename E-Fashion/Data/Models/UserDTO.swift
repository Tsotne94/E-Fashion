//
//  UserDTO.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 19.01.25.
//

import FirebaseAuth

struct UserDTO {
    let uid: String
    let email: String?
    let displayName: String?
    let imageUrl: String?
    
    init(from firebaseUser: FirebaseAuth.User) {
        self.uid = firebaseUser.uid
        self.email = firebaseUser.email
        self.displayName = firebaseUser.displayName
        self.imageUrl = firebaseUser.photoURL?.absoluteString
    }
    
    init(from user: User) {
        self.uid = user.uid
        self.email = user.email
        self.displayName = user.displayName
        self.imageUrl = user.imageUrl
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "uid": uid,
            "email": email ?? "",
            "displayName": displayName ?? "",
            "imageUrl": imageUrl ?? ""
        ]
    }
    
    func toUser() -> User {
        return User(
            uid: uid,
            email: email,
            displayName: displayName,
            imageUrl: imageUrl
        )
    }
}
