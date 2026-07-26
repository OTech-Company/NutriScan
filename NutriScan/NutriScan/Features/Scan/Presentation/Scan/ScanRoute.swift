import SwiftUI

enum ScanRoute: Route {
    case scan
    case scanDetail(scanId: String, imageData: Data)
    case scanDetailFromDTO(detail: ScanDetail, imageData: Data)

    @ViewBuilder
    var destination: some View {
        switch self {
        case .scan:
            ScanScreen()
        case .scanDetail(let scanId, _):
            ProductDetailsScreen(scanId: scanId)
        case .scanDetailFromDTO(let detail, _):
            ProductDetailsScreen(detail: detail)
        }
    }
}
