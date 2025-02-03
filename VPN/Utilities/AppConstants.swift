import Foundation

enum AppConstants {
    static let API_URL = "https://api.planetproxy.io" // Replace with your actual API URL
    
    enum Auth {
        static let tokenKey = "authToken"
        static let refreshTokenKey = "refreshToken"
        static let userKey = "currentUser"
    }
    
    enum ErrorMessages {
        static let invalidEmail = "Please enter a valid email address"
        static let invalidPassword = "Password must be at least 8 characters"
        static let emailInUse = "This email is already registered"
        static let userNotFound = "No account found with this email"
        static let wrongPassword = "Incorrect password"
        static let networkError = "Network error. Please check your connection"
        static let unknownError = "An unexpected error occurred"
    }
}