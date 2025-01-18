//
//  User.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//
import FirebaseAuth

public struct User {
    let uid: String
    let email: String?
    let displayName: String?
    
    // Initialize the struct from Firebase User
    init(firebaseUser: FirebaseAuth.User) {
        self.uid = firebaseUser.uid
        self.email = firebaseUser.email
        self.displayName = firebaseUser.displayName
    }
    
    // Default initializer for empty User (for error cases)
    init() {
        self.uid = ""
        self.email = nil
        self.displayName = nil
    }
}

