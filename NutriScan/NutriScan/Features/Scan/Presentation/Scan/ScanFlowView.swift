import SwiftUI

/// Owns the Scan tab's own NavigationStack + AppRouter.
struct ScanFlowView: View {
    @StateObject private var router = AppRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            ScanScreen()
                .navigationDestination(for: AnyRoute.self) { route in
                    route.view()
                }
        }
        .environmentObject(router)
    }
}
