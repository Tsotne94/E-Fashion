//
//  SignUpError.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 17.01.25.
//
public enum SignUpError: Error, CustomStringConvertible {
    case invalidEmail
    case emailAlreadyInUse
    case weakPassword
    case networkError
    case unknownError(String)

    public var description: String {
        switch self {
        case .invalidEmail:
            return "The email address is not valid."
        case .emailAlreadyInUse:
            return "This email address is already in use. Please use a different one."
        case .weakPassword:
            return "The password is too weak. Please use a stronger password."
        case .networkError:
            return "A network error occurred. Please check your internet connection."
        case .unknownError(let message):
            return "An unexpected error occurred: \(message)"
        }
    }
}
