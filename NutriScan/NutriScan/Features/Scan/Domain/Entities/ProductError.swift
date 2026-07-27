import Foundation

enum ScanError: Error, Equatable {
    case scanNotFound(scanId: String)
    case network(String)
    case decoding
    case unknown

    var userMessage: String {
        switch self {
        case .scanNotFound(let scanId):
            return "No scan found with ID \(scanId)."
        case .network:
            return "Couldn't reach the server. Check your connection."
        case .decoding:
            return "Something went wrong reading the scan data."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}
