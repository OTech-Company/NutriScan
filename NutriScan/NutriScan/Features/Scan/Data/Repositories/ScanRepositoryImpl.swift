import Foundation

final class ScanRepositoryImpl: ScanRepository {

    private let apiService: ScanAPIServicing

    init(apiService: ScanAPIServicing = ScanAPIService()) {
        self.apiService = apiService
    }

    func uploadScan(imageData: Data, filename: String) async throws -> String {
        try await apiService.uploadScan(imageData: imageData, filename: filename)
    }

    func fetchScanResult(scanId: String) async throws -> ScanResult {
        let dto = try await apiService.fetchScanResult(scanId: scanId)
        return ScanMapper.toDomain(dto)
    }

    func observeScanResult(scanId: String) -> AsyncThrowingStream<ScanResult, Error> {
        AsyncThrowingStream { continuation in
            let stream = self.apiService.observeScanResult(scanId: scanId)
            let task = Task {
                do {
                    for try await dto in stream {
                        let result = ScanMapper.toDomain(dto)
                        continuation.yield(result)
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
            continuation.onTermination = { @Sendable _ in
                task.cancel()
            }
        }
    }
}
