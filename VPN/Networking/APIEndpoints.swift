import Foundation

struct APIEndpoints {
    private static let baseURL = "https://api.planet-proxy.com/gateway/api"

    struct Servers {
        static func getVpnServers() -> URL? {
            return URL(string: "\(baseURL)/servers")
        }

        static func getVpnSession(countryId: Int) -> URL? {
            return URL(string: "\(baseURL)/peer/\(countryId)")
        }
    }

    struct Auth {
        static func login() -> URL? {
            return URL(string: "\(baseURL)/auth/login")
        }
    }

    struct Session {
        static func startVpnSession() -> URL? {
            return URL(string: "\(baseURL)/session")
        }

        static func endVpnSession() -> URL? {
            return URL(string: "\(baseURL)/session/end")
        }
    }

    struct Payments {
        static func createSubscription(subscriptionPlan: String) -> URL? {
            return URL(string: "\(baseURL)/payments/subscriptions/create/\(subscriptionPlan)")
        }
    }
    
    struct User {
            static func getUser() -> URL? {
                return URL(string: "\(baseURL)/auth/user")
            }
        }

}
