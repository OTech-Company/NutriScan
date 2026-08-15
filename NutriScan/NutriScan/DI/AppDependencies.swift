//
//  AppDependencies.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 22/07/2026.
//
//  Composition root: runs every feature's Assembly in dependency order.
//  Adding a new feature means adding one line here, not editing
//  registration logic that belongs to another feature.
//
import Foundation

struct AppDependencies {

    /// Ordered so Core (shared services) registers before any feature
    /// that depends on it (e.g. NetworkServiceProtocol before ProfileAssembly).
    private static let assemblies: [Assembly] = [
        CoreAssembly(),
        SharedProfileAssembly(),
        StepTrackerAssembly(),
        NotificationHistoryAssembly(),
        CaloriesAssembly(),
        NewsAssembly(),
        NotificationAssembly(),
        NotificationSettingsAssembly(),
        AuthAssembly(),
        ExerciseAssembly(),
        ProfileAssembly(),
        EditProfileAssembly(),
        ScanAssembly(),
        RAGAssembly(),
        SettingsAssembly(),
        AccountRestorationAssembly(),
        ProductDetailsAssembly(),
        CaloriesHistoryAssembly(),
        ScanHistoryAssembly(),
        HomeAssembly()
    ]

    static func setup() {
        let container = DIContainer.shared
        assemblies.forEach { $0.assemble(container: container) }
    }
}
