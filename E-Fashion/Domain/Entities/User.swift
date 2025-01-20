//
//  User.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//
public struct User {
    let uid: String
    let email: String?
    let displayName: String?
    let imageUrl: String?
    
    init(uid: String, email: String? = nil, displayName: String? = nil, imageUrl: String? = nil) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
        self.imageUrl = imageUrl
    }
    
    init() {
        self.uid = ""
        self.email = nil
        self.displayName = nil
        self.imageUrl = nil
    }
}


