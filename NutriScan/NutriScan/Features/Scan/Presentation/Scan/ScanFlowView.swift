//
//  ScanFlowView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//


import SwiftUI

/// Owns the Scan tab's own `NavigationStack` + `AppRouter`. Scoped to this
/// tab only, so pushing a product detail screen from a scan result never
/// touches Home's or Profile's back-stack.
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
