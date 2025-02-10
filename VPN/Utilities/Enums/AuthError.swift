//
//  AuthError.swift
//  VPN
//
//  Created by Arunachalam K on 04/02/2025.
//


// MARK: - AuthError Enum
enum AuthError: Error {
    case userNotFound
    case wrongPassword
    case emailAlreadyInUse
    case invalidEmail
    case networkError
    case userDisabled
    case unknown(Error)
    case custom(String) // ✅ Custom error messages

    var localizedDescription: String {
        switch self {
        case .userNotFound:
            return "User does not exist. Please sign up."
        case .wrongPassword:
            return "Incorrect password. Please try again."
        case .emailAlreadyInUse:
            return "This email is already registered. Try signing in instead."
        case .invalidEmail:
            return "Invalid email format. Please enter a valid email."
        case .networkError:
            return "Network error. Please check your internet connection."
        case .userDisabled:
            return "Your account has been disabled. Contact support."
        case .unknown(let error):
            return error.localizedDescription
        case .custom(let message): // ✅ Return custom message
            return message
        }
    }
}

