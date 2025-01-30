import Foundation

class BaseRepository {
    // Add common data handling methods here

    func complete<T>(_ task: @escaping () async -> T) async -> T {
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<T, Error>!
        Task {
            result = await Result { try await task() }
            semaphore.signal()
        }
        _ = semaphore.wait()
        return try result.get()
    }
}
