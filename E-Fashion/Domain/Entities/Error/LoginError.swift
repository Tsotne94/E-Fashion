//
//  LoginError 2.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 17.01.25.
//

import Foundation

public enum LoginError: MappableError {
    case wrongPassword
    case userNotFound
    case invalidEmail
    case networkError
    case invalidCredential
    case userDisabled
    case tooManyRequests
    case operationNotAllowed
    case invalidVerificationCode
    case invalidVerificationID
    case sessionExpired
    case userTokenExpired
    case accountDisabled
    case unknownError(String)
    
    public var description: String {
        switch self {
        case .wrongPassword:
            return "Incorrect password. Please double-check and try again."
        case .userNotFound:
            return "No account found with this email. Please check your email or sign up for a new account."
        case .invalidEmail:
            return "The email address entered is invalid. Please check it and try again."
        case .networkError:
            return "Unable to connect to the internet. Please check your connection and try again."
        case .invalidCredential:
            return "The login credentials are invalid or have expired. Please log in again."
        case .userDisabled:
            return "Your account has been disabled. Please contact support for further assistance."
        case .tooManyRequests:
            return "You have attempted to log in too many times. Please wait a few minutes and try again."
        case .operationNotAllowed:
            return "This login method is not enabled. Please use another method to log in."
        case .invalidVerificationCode:
            return "The verification code entered is invalid. Please try again or request a new code."
        case .invalidVerificationID:
            return "The verification ID is invalid or expired. Please request a new one."
        case .sessionExpired:
            return "Your session has expired. Please log in again to continue."
        case .userTokenExpired:
            return "Your session token has expired. Please log in again to continue."
        case .accountDisabled:
            return "Your account is currently disabled. Please contact support for assistance."
        case .unknownError(let message):
            return "An unexpected error occurred: \(message)"
        }
    }
    
    public static func mapError(_ code: Int, message: String) -> Self {
        switch code {
        case 17008: return .invalidEmail
        case 17009: return .wrongPassword
        case 17011: return .userNotFound
        case 17016: return .invalidCredential
        case 17025: return .userDisabled
        case 17010: return .tooManyRequests
        case 17006: return .operationNotAllowed
        case 17028: return .invalidVerificationCode
        case 17029: return .invalidVerificationID
        case 17031: return .sessionExpired
        case 17017: return .userTokenExpired
        case -1009: return .networkError
        case 17004: return .invalidCredential
        default:
            print("Unmapped error code: \(code), message: \(message)")
            return .unknownError(message)
        }
    }
}
