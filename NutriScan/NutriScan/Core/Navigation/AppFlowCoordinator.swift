//
//  AppFlowCoordinator.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//
import SwiftUI

/// Decides which top-level `AppFlow` is currently shown, and exposes
/// the transitions between them. Injected once at the root and read
/// via `@EnvironmentObject` by any screen that can trigger a flow
/// change (e.g. `OnboardingView` finishing, `LoginView` succeeding,
/// a logout button inside Profile).
final class AppFlowCoordinator: ObservableObject {
    @Published private(set) var flow: AppFlow
    @Published var selectedTab: AppTab = .home
    @Published var pendingDeletionDate: Date? = nil
    @Published var splashAlertItem: SplashAlertItem? = nil

    let mainTabNavigation: MainTabNavigationStore
    
    private let fetchAndCacheProfileUseCase: FetchAndCacheProfileUseCaseProtocol

    init(
        fetchAndCacheProfileUseCase: FetchAndCacheProfileUseCaseProtocol =
            DIContainer.shared.resolve(
                type: FetchAndCacheProfileUseCaseProtocol.self),
        mainTabNavigation: MainTabNavigationStore = MainTabNavigationStore(),
        initialFlow: AppFlow = .splash,
        observesSessionExpiration: Bool = true
    ) {
        self.fetchAndCacheProfileUseCase = fetchAndCacheProfileUseCase
        self.mainTabNavigation = mainTabNavigation
        self.flow = initialFlow

        if observesSessionExpiration {
            NotificationCenter.default.addObserver(
                forName: .userDidSessionExpire,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.logout()
            }
        }
    }

    private var hasCompletedOnboarding: Bool {
        UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    }

    private var isAuthenticated: Bool {
        do {
            _ = try KeychainManager.shared.get(key: .accessToken)
            return true
        } catch {
            return false
        }
    }

    private var hasCompletedProfileSetup: Bool {
        UserDefaults.standard.bool(forKey: "hasCompletedProfileSetup")
    }

    private func parseDeletionDate(from message: String) -> Date? {
        guard let dateStr = message.components(separatedBy: "on ").last?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateStr)
    }

    @MainActor
    private func fetchProfileAndTransitionToMain() async {
        do {
            _ = try await fetchAndCacheProfileUseCase.execute()
            flow = .main
        } catch let error as NetworkError {
            if case .apiError(let apiError) = error,
               apiError.error == "ACCOUNT_PENDING_DELETION" || apiError.status == 409 {
                pendingDeletionDate = parseDeletionDate(from: apiError.message ?? "")
                flow = .pendingDeletion
            } else if case .unauthorized = error {
                logout()
            } else {
                splashAlertItem = SplashAlertItem(error: error)
            }
        } catch {
            splashAlertItem = SplashAlertItem(error: error)
        }
    }

    @MainActor
    func finishSplash() {
        Task {
            if !hasCompletedOnboarding {
                flow = .onboarding
            } else if !isAuthenticated {
                flow = .auth
            } else if !hasCompletedProfileSetup {
                flow = .profileSetup
            } else {
                await fetchProfileAndTransitionToMain()
            }
        }
    }

    @MainActor
    func retryFetchProfile() {
        Task {
            await fetchProfileAndTransitionToMain()
        }
    }

    func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        flow = .auth
    }

    @MainActor
    func didAuthenticate(isPendingSetup: Bool = false, email: String? = nil) {
        if isPendingSetup {
            UserDefaults.standard.set(false, forKey: "hasCompletedProfileSetup")
            if let email = email {
                UserDefaults.standard.set(email, forKey: "currentSetupEmail")
            }
            flow = .profileSetup
        } else {
            UserDefaults.standard.set(true, forKey: "hasCompletedProfileSetup")
            Task {
                await fetchProfileAndTransitionToMain()
            }
        }
    }

    @MainActor
    func didRestoreAccount() {
        pendingDeletionDate = nil
        flow = .main

        Task {
            _ = try? await fetchAndCacheProfileUseCase.execute()
        }
    }

    @MainActor
    func finishProfileSetup() async {
        if let email = UserDefaults.standard.string(forKey: "currentSetupEmail")
        {
            UserDefaults.standard.removeObject(
                forKey: "isPendingProfileSetup_\(email)")
            UserDefaults.standard.removeObject(forKey: "currentSetupEmail")
        }
        UserDefaults.standard.set(true, forKey: "hasCompletedProfileSetup")
        
        await fetchProfileAndTransitionToMain()
    }

    func logout() {
        try? KeychainManager.shared.delete(key: .accessToken)
        try? KeychainManager.shared.delete(key: .refreshToken)

        let store = DIContainer.shared.resolve(type: UserProfileStore.self)
        store.clear()
        
        pendingDeletionDate = nil

        selectedTab = .home
        mainTabNavigation.resetAll()

        flow = .auth
    }
}

struct SplashAlertItem: Identifiable, Equatable {
    let id: UUID
    let error: Error

    init(error: Error) {
        self.id = UUID()
        self.error = error
    }

    static func == (lhs: SplashAlertItem, rhs: SplashAlertItem) -> Bool {
        lhs.id == rhs.id
    }
}
