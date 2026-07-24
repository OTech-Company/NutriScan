import Foundation

struct ScanHistoryResponseDTO: Decodable {
    let content: [ScanHistoryItemDTO]
    let totalElements: Int
    let totalPages: Int
    let number: Int
    let size: Int
}

struct ScanHistoryItemDTO: Decodable {
    let scanId: String
    let imageUrl: String?
    let verdict: ScanVerdict
    let scannedAt: Date?
}
