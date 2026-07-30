import SwiftUI

enum ScanRoute: Route {
    case scan
    case scanDetail(detail: ScanDetail, imageData: Data)

    @MainActor
    @ViewBuilder
    var destination: some View {
        switch self {
        case .scan:
            ScanScreen()
        case .scanDetail(let detail, _):
            ProductDetailsScreen(scanDetail: detail)
        }
    }
}
