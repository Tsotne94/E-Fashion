//
//  SignUpError.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 17.01.25.
//
public enum SignUpError: MappableError {
    case invalidEmail
    case emailAlreadyInUse
    case weakPassword
    case networkError
    case operationNotAllowed
    case invalidPassword
    case missingEmail
    case tooManyRequests
    case invalidPhoneNumber
    case invalidVerificationCode
    case credentialAlreadyInUse
    case unknownError(String)

    public var description: String {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address."
        case .emailAlreadyInUse:
            return "This email is already registered. Please try logging in instead."
        case .weakPassword:
            return "Please choose a stronger password. Use at least 6 characters with a mix of letters and numbers."
        case .networkError:
            return "A network error occurred. Please check your connection."
        case .operationNotAllowed:
            return "This sign-up method is not enabled. Please use a different method."
        case .invalidPassword:
            return "Please enter a valid password."
        case .missingEmail:
            return "Please enter an email address."
        case .tooManyRequests:
            return "Too many attempts. Please try again later."
        case .invalidPhoneNumber:
            return "Please enter a valid phone number."
        case .invalidVerificationCode:
            return "The verification code is invalid. Please try again."
        case .credentialAlreadyInUse:
            return "This credential is already associated with a different user account."
        case .unknownError(let message):
            return "An unexpected error occurred: \(message)"
        }
    }

    public static func mapError(_ code: Int, message: String) -> Self {
        switch code {
        case 17008: return .invalidEmail
        case 17007: return .emailAlreadyInUse
        case 17026: return .weakPassword
        case 17006: return .operationNotAllowed
        case 17009: return .invalidPassword
        case 17034: return .missingEmail
        case 17010: return .tooManyRequests
        case 17038: return .invalidPhoneNumber        
        case 17014: return .invalidVerificationCode
        case 17025: return .credentialAlreadyInUse
        case -1009: return .networkError
        default: return .unknownError(message)
        }
    }
}

