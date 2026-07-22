//
//  NutriScanApp.swift
//  NutriScan
//
//  Created by Youssef Abd El-Fatah on 13/07/2026.
//

import SwiftUI
 
@main
struct NutriScanApp: App {
    
    init() {
        AppDependencies.setup()
    }
    
    var body: some Scene {
        WindowGroup {
            RootCoordinatorView()
        }
    }
}
