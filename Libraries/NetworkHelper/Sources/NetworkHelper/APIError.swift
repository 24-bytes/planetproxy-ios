import Foundation

public enum APIError: Error {
    case invalidURL
    case requestFailed(String)
    case decodingFailed
    case unauthorized
    case unknown(Error)

    public var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "The requested URL is invalid."
        case .requestFailed(let message):
            return message
        case .decodingFailed:
            return "Failed to decode response data."
        case .unauthorized:
            return "Unauthorized request. Please log in again."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
