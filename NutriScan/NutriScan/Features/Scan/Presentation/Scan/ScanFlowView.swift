import SwiftUI

/// Owns the Scan tab's NavigationStack and receives its persistent router.
struct ScanFlowView: View {
    @ObservedObject var router: AppRouter

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
