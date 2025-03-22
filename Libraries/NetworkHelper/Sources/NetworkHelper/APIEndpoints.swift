import Foundation

public struct APIEndpoints {
    private static let baseURL = "https://api.planet-proxy.com/gateway/api"

    public struct Servers {
        public static func getVpnServers() -> URL? {
            return URL(string: "\(baseURL)/servers")
        }

        public static func getVpnSession(countryId: Int) -> URL? {
            return URL(string: "\(baseURL)/peer/\(countryId)")
        }
    }

    public struct Auth {
        public static func login() -> URL? {
            return URL(string: "\(baseURL)/auth/login")
        }
    }

    public struct Session {
        public static func startVpnSession() -> URL? {
            return URL(string: "\(baseURL)/session")
        }

        public static func endVpnSession() -> URL? {
            return URL(string: "\(baseURL)/session/end")
        }
    }

    public struct Payments {
        public static func createSubscription(subscriptionPlan: String) -> URL? {
            return URL(string: "\(baseURL)/payments/subscriptions/create/\(subscriptionPlan)")
        }
    }
    
    public struct User {
        public static func getUser() -> URL? {
            return URL(string: "\(baseURL)/auth/user")
        }
    }
}
