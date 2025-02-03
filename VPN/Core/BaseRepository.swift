import Foundation

class BaseRepository {
    // Add common data handling methods here
    func complete<T>(_ task: @escaping () async throws -> T) async throws -> T {
        return try await task()
    }
}
