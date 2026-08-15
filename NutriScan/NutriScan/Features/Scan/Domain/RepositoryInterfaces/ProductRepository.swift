import Foundation

protocol ScanRepository {
    func fetchScans(page: Int, size: Int) async throws -> ScanPage
    func submitScan(imageData: Data) async throws -> ScanSubmission
    func submitBarcode(barcode: String) async throws -> ScanSubmission
    func fetchScanDetail(scanId: String) async throws -> ScanDetail
}
