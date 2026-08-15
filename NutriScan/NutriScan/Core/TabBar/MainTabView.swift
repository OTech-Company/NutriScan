//
//  MainTabView.swift
//  NutriScan
//
//  Created by Osama Hosam on 14/07/2026.
//


import SwiftUI

/// Composes the app's tabs. Lives in Core/Navigation because it's
/// app-level composition (it must know about Home + Profile), same
/// reasoning as RootCoordinatorView.
///
/// Each tab renders its feature's own "FlowView" (e.g. `HomeFlowView`).
/// The main navigation store owns the routers while each flow owns its
/// `NavigationStack`, preserving independent history across tab changes.
struct MainTabView: View {
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator
    @State private var favoritesViewModel = FavoritesFactory.makeFavoritesViewModel()

    var body: some View {
        MainTabShell(
            selectedTab: $flowCoordinator.selectedTab,
            navigationStore: flowCoordinator.mainTabNavigation,
            favoritesViewModel: favoritesViewModel
        )
    }
}

private struct MainTabShell: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Binding var selectedTab: AppTab
    @ObservedObject var navigationStore: MainTabNavigationStore
    let favoritesViewModel: FavoritesViewModel

    private var showsCustomTabBar: Bool {
        navigationStore.isAtRoot(selectedTab)
    }

    private var tabBarVisibilityAnimation: Animation {
        reduceMotion
            ? .easeOut(duration: 0.15)
            : .spring(response: 0.42, dampingFraction: 0.88, blendDuration: 0.1)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeFlowView(router: navigationStore.router(for: .home))
                    .toolbar(.hidden, for: .tabBar)
                    .tag(AppTab.home)
                
                CaloriesFlowView(router: navigationStore.router(for: .calories))
                    .toolbar(.hidden, for: .tabBar)
                    .tag(AppTab.calories)
                
                ScanFlowView(router: navigationStore.router(for: .scan))
                    .toolbar(.hidden, for: .tabBar)
                    .tag(AppTab.scan)

                FavoritesFlowView(
                    router: navigationStore.router(for: .bookmark),
                    viewModel: favoritesViewModel
                )
                    .toolbar(.hidden, for: .tabBar)
                    .tag(AppTab.bookmark)

                ProfileFlowView(router: navigationStore.router(for: .profile))
                    .toolbar(.hidden, for: .tabBar)
                    .tag(AppTab.profile)
            }
            .toolbar(.hidden, for: .tabBar)

            CustomAnimatedTabBar(selectedTab: $selectedTab)
                .customTealShadow()
                .opacity(showsCustomTabBar ? 1 : 0)
                .offset(
                    y: showsCustomTabBar || reduceMotion
                        ? 0
                        : CustomAnimatedTabBar.barHeight + 40
                )
                .scaleEffect(
                    x: 1,
                    y: showsCustomTabBar || reduceMotion ? 1 : 0.96,
                    anchor: .bottom
                )
                .allowsHitTesting(showsCustomTabBar)
                .accessibilityHidden(!showsCustomTabBar)
                .zIndex(1)
                .animation(tabBarVisibilityAnimation, value: showsCustomTabBar)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    MainTabView()
        .environmentObject(AppFlowCoordinator())
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    MainTabView()
        .environmentObject(AppFlowCoordinator())
        .preferredColorScheme(.dark)
}
