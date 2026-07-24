import Foundation

protocol ScanRepository {
    func uploadScan(imageData: Data, filename: String) async throws -> String
    func fetchScanResult(scanId: String) async throws -> ScanResult
    func observeScanResult(scanId: String) -> AsyncThrowingStream<ScanResult, Error>
}
