import SwiftUI

enum ScanRoute: Route {
    case scan
    case scanDetail(detail: ScanDetail, imageData: Data)

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
