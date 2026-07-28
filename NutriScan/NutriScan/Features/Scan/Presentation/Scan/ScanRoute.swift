import SwiftUI

enum ScanRoute: Route {
    case scan

    @ViewBuilder
    var destination: some View {
        switch self {
        case .scan:
            ScanScreen()
        }
    }
}
