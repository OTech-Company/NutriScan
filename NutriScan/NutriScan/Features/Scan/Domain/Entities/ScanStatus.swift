import Foundation

enum ScanStatus: String, Decodable {
    case processing = "PROCESSING"
    case completed = "COMPLETED"
    case failed = "FAILED"
}
