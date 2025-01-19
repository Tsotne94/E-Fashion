//
//  LoginError 2.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 17.01.25.
//
public enum LoginError: Error, CustomStringConvertible, Equatable {
    case invalidEmail
    case wrongPassword
    case userNotFound
    case networkError
    case unknownError(String)

    public var description: String {
        switch self {
        case .invalidEmail:
            return "The email address is not valid."
        case .wrongPassword:
            return "The password is incorrect. Please try again."
        case .userNotFound:
            return "No account found with this email address."
        case .networkError:
            return "A network error occurred. Please check your internet connection."
        case .unknownError(let message):
            return "An unexpected error occurred: \(message)"
        }
    }
}
