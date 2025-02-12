import Foundation

struct FormValidator {

    /// Validate email format
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    /// Validate strong password: 1 uppercase, 1 digit, 1 symbol, 8+ length
    static func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = #"^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"#
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }

    /// Validate if fields are not empty
    static func isNotEmpty(_ text: String) -> Bool {
        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
