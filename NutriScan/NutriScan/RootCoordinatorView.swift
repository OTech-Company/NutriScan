//
//  RootCoordinatorView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//

import SwiftUI

/// The ONLY place in the entire app that wires top-level flows together.
///
/// You touch this file once, when the app is created. You never touch
/// it again when adding new screens *within* an existing flow (those
/// register themselves via `Route`/`AnyRoute`), and you only touch it
/// when adding a brand new *top-level flow* (rare — e.g. a "force
/// update" screen).
///
/// Each flow below (Splash, Onboarding, Auth, Main) owns its own
/// internal navigation — this view just decides which one is visible.
/// 
struct RootCoordinatorView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var flowCoordinator: AppFlowCoordinator
    @State private var dailyActivitySyncCoordinator = DIContainer.shared.resolve(
        type: CaloriesActivitySyncCoordinator.self
    )
    @AppStorage("appAppearance") private var appAppearance: AppAppearance = .system
    @AppStorage("appLanguage") private var appLanguage: AppLanguage = .english
    private let isUITesting: Bool

    init() {
        let isUITesting = ProcessInfo.processInfo.arguments.contains("-ui-testing-main-flow")
        self.isUITesting = isUITesting
        _flowCoordinator = StateObject(
            wrappedValue: AppFlowCoordinator(
                initialFlow: isUITesting ? .main : .splash,
                observesSessionExpiration: !isUITesting
            )
        )
    }

    var body: some View {
        currentFlowView
            .preferredColorScheme(appAppearance.colorScheme)
            .environment(\.locale, appLanguage.locale)
            .environment(\.layoutDirection, appLanguage.layoutDirection)
            .environmentObject(flowCoordinator)
            .animation(.default, value: flowCoordinator.flow)
            .id(appLanguage)
            .task(id: flowCoordinator.flow) {
                guard !isUITesting, flowCoordinator.flow == .main else { return }
                await dailyActivitySyncCoordinator.synchronizePendingDates()
            }
            .onChange(of: scenePhase) { _, phase in
                guard !isUITesting,
                      phase == .active,
                      flowCoordinator.flow == .main else { return }
                Task {
                    await dailyActivitySyncCoordinator.synchronizePendingDates()
                }
            }
             .task {
                guard !isUITesting else { return }
                let bootstrapper = DIContainer.shared.resolve(type: NotificationBootstrapperProtocol.self)
                await bootstrapper.start()
            }
            .customAlert(
                item: $flowCoordinator.splashAlertItem,
                config: { item in
                    let isNoInternet: Bool
                    if let networkError = item.error as? NetworkError, case .noInternet = networkError {
                        isNoInternet = true
                    } else if let urlError = item.error as? URLError, urlError.code == .notConnectedToInternet || urlError.code == .networkConnectionLost {
                        isNoInternet = true
                    } else {
                        isNoInternet = false
                    }
                    
                    return CustomAlertConfig(
                        type: isNoInternet ? .noInternet : .error,
                        title: isNoInternet ? LocalizationKeys.Common.noInternetConnection.localized : LocalizationKeys.Common.error.localized,
                        message: item.error.localizedDescription,
                        primaryButton: CustomAlertButton(LocalizationKeys.Common.tryAgain.localized, role: .standard)
                    )
                },
                primaryAction: { _ in
                    flowCoordinator.retryFetchProfile()
                }
            )
    }

    @ViewBuilder
    private var currentFlowView: some View {
        switch flowCoordinator.flow {
        case .splash:
            SplashView()
        case .onboarding:
            OnboardingFlowView()
        case .auth:
            AuthFlowView()
        case .profileSetup:
            ProfileSetupFlowView()
        case .main:
            MainTabView()
        case .pendingDeletion:
            AccountRestorationFactory.makeAccountRestorationView()
        }

    }
}
