import Alamofire

class APIClient {
    static let shared = APIClient()
    
    private init() {}

    func request<T: Codable>(
        url: String,
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseDecodable(of: BaseResponseData<T>.self) { response in
                    switch response.result {
                    case .success(let baseResponse):
                        if let data = baseResponse.data {
                            continuation.resume(returning: data)
                        } else {
                            continuation.resume(throwing: APIError.decodingFailed)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: APIError.requestFailed(error.localizedDescription))
                    }
                }
        }
    }

    // ✅ New Function to Handle Void Responses
    func requestWithoutResponse(
        url: String,
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = nil
    ) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        continuation.resume()
                    case .failure(let error):
                        continuation.resume(throwing: APIError.requestFailed(error.localizedDescription))
                    }
                }
        }
    }
}
