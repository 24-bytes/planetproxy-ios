import Alamofire

protocol VpnRemoteServiceProtocol {
    func getVpnServers() async throws -> [ServerDetail]
    func getVpnSession(countryId: Int) async throws -> String
    func authenticate(token: String, request: AuthenticateUserRequest) async throws -> AuthenticateUserResponse
    func startVpnSession(request: StartSessionRequest) async throws -> StartSessionResult
    func endVpnSession(request: EndSessionRequest) async throws
    func createSubscription(subscriptionPlan: String) async throws -> CreateSubscriptionResponse
    func getUser() async throws -> UserModel
}

class VpnRemoteService: VpnRemoteServiceProtocol {
    private let apiClient = APIClient.shared
    
    func getVpnServers() async throws -> [ServerDetail] {
        guard let url = APIEndpoints.Servers.getVpnServers()?.absoluteString else {
            throw APIError.invalidURL
        }
        return try await apiClient.request(url: url, method: .get)
    }

    func getVpnSession(countryId: Int) async throws -> String {
        guard let url = APIEndpoints.Servers.getVpnSession(countryId: countryId)?.absoluteString else {
            throw APIError.invalidURL
        }
        return try await apiClient.request(url: url, method: .get)
    }

    func authenticate(token: String, request: AuthenticateUserRequest) async throws -> AuthenticateUserResponse {
        guard let url = APIEndpoints.Auth.login()?.absoluteString else {
            throw APIError.invalidURL
        }
        
        let headers: HTTPHeaders = ["Authorization": token]
        let parameters = try request.toDictionary()

        return try await apiClient.request(url: url, method: .post, parameters: parameters, headers: headers)
    }

    func startVpnSession(request: StartSessionRequest) async throws -> StartSessionResult {
        guard let url = APIEndpoints.Session.startVpnSession()?.absoluteString else {
            throw APIError.invalidURL
        }
        
        let parameters = try request.toDictionary()
        return try await apiClient.request(url: url, method: .post, parameters: parameters)
    }

    func endVpnSession(request: EndSessionRequest) async throws {
        guard let url = APIEndpoints.Session.endVpnSession()?.absoluteString else {
            throw APIError.invalidURL
        }

        let parameters = try request.toDictionary()
        try await apiClient.requestWithoutResponse(url: url, method: .post, parameters: parameters)
    }


    func createSubscription(subscriptionPlan: String) async throws -> CreateSubscriptionResponse {
        guard let url = APIEndpoints.Payments.createSubscription(subscriptionPlan: subscriptionPlan)?.absoluteString else {
            throw APIError.invalidURL
        }
        
        return try await apiClient.request(url: url, method: .get)
    }
    
    func getUser() async throws -> UserModel {
            guard let url = APIEndpoints.User.getUser()?.absoluteString else {
                throw APIError.invalidURL
            }
            return try await apiClient.request(url: url, method: .get)
        }

}
