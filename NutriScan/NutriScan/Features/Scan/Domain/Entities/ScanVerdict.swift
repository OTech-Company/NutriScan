import Foundation

enum ScanVerdict: String, Decodable, CaseIterable {
    case safe = "SAFE"
    case unsafe = "UNSAFE"
    case caution = "CAUTION"
}
