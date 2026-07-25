//
//  CaloriesFlowView.swift
//  NutriScan
//
//  Created by albaraa alsayed on 22/07/2026.
//

import SwiftUI

struct CaloriesFlowView: View {
    @StateObject private var router = AppRouter()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            CaloriesScreen()
                .navigationDestination(for: AnyRoute.self) { route in
                    route.view()
                }
        }
        .environmentObject(router)
    }
}
