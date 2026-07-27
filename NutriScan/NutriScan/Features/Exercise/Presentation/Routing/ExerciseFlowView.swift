//
//  ExerciseFlowView.swift
//  NutriScan
//

import SwiftUI

/// Owns the Exercise tab's own `NavigationStack` + `AppRouter`.
/// Scoped to this tab only — back-stack is independent from all other tabs.
struct ExerciseFlowView: View {
    @StateObject private var router = AppRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            ExercisesView()
                .navigationDestination(for: AnyRoute.self) { route in
                    route.view()
                }
        }
        .environmentObject(router)
    }
}
