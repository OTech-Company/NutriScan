import Foundation

enum ScanError: Error, Equatable {
    case scanNotFound(scanId: String)
    case network(String)
    case decoding
    case unknown

    var userMessage: String {
        switch self {
        case .scanNotFound(let scanId):
            return "\(LocalizationKeys.Scan.noScanFoundWithId.localized) \(scanId)."
        case .network:
            return LocalizationKeys.Common.noInternetConnection.localized
        case .decoding:
            return LocalizationKeys.Common.actionFailed.localized
        case .unknown:
            return LocalizationKeys.Common.somethingWentWrong.localized
        }
    }
}
