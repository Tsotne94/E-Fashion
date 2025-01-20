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
    case accountDisabled
    case unknownError(String)
    
    public var description: String {
        switch self {
        case .invalidEmail:
            return "The email address entered is not valid. Please double-check and try again."
        case .emailAlreadyInUse:
            return "This email is already associated with an account. Please log in instead."
        case .weakPassword:
            return "Your password is too weak. Please use at least 6 characters with a mix of letters and numbers."
        case .networkError:
            return "A network error occurred. Please check your internet connection and try again."
        case .operationNotAllowed:
            return "This sign-up method is currently not allowed. Please choose a different method."
        case .invalidPassword:
            return "The password entered is incorrect or invalid. Please try again."
        case .missingEmail:
            return "No email address was provided. Please enter an email address to continue."
        case .tooManyRequests:
            return "You have made too many attempts. Please wait a moment and try again later."
        case .invalidPhoneNumber:
            return "The phone number entered is not valid. Please check the number and try again."
        case .invalidVerificationCode:
            return "The verification code entered is incorrect. Please double-check and try again."
        case .credentialAlreadyInUse:
            return "This credential is already linked to another account. Please use a different one."
        case .accountDisabled:
            return "This account has been disabled. Please contact support for assistance."
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
        case 17004: return .accountDisabled
        case -1009: return .networkError
        default: return .unknownError(message)
        }
    }
}


