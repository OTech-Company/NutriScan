import Foundation

enum ScanError: Error, Equatable {
    case emptyImage
    case uploadFailed(String)
    case websocketFailed(String)
    case scanFailed(String)

    var userMessage: String {
        switch self {
        case .emptyImage:
            return "No image to scan. Please capture or select a photo."
        case .uploadFailed(let message):
            return "Failed to upload image: \(message)"
        case .websocketFailed(let message):
            return "Connection lost: \(message)"
        case .scanFailed(let message):
            return "Scan failed: \(message)"
        }
    }
}
