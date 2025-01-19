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
    case unknownError(String)

    public var description: String {
        switch self {
        case .wrongPassword:
            return "The password is incorrect."
        case .userNotFound:
            return "No user found with this email."
        case .invalidEmail:
            return "The email address is invalid."
        case .networkError:
            return "A network error occurred. Please check your connection."
        case .invalidCredential:
            return "Your login session has expired. Please try again."
        case .userDisabled:
            return "This account has been disabled. Please contact support."
        case .tooManyRequests:
            return "Too many failed attempts. Please try again later."
        case .operationNotAllowed:
            return "This login method is not enabled. Please use a different method."
        case .invalidVerificationCode:
            return "The verification code is invalid. Please try again."
        case .invalidVerificationID:
            return "Invalid verification. Please request a new code."
        case .sessionExpired:
            return "Your session has expired. Please log in again."
        case .userTokenExpired:
            return "Your login has expired. Please log in again."
        case .unknownError(let message):
            return "An unexpected error occurred: \(message)"
        }
    }

    public static func mapError(_ code: Int, message: String) -> Self {
        switch code {
        case 17009: return .wrongPassword
        case 17011: return .userNotFound
        case 17008: return .invalidEmail
        case 17004: return .invalidCredential
        case 17005: return .userDisabled
        case 17010: return .tooManyRequests
        case 17006: return .operationNotAllowed
        case 17014: return .invalidVerificationCode
        case 17012: return .invalidVerificationID
        case 17021: return .sessionExpired
        case 17495: return .userTokenExpired
        case -1009: return .networkError
        default: return .unknownError(message)
        }
    }

