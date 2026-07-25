import SwiftUI

enum ScanRoute: Route {
    case scan
    case scanDetail(scanId: String)

    @ViewBuilder
    var destination: some View {
        switch self {
        case .scan:
            ScanScreen()
        case .scanDetail(let scanId):
            ProductDetailView(scanId: scanId)
        }
    }
}
