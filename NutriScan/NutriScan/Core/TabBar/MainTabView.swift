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
/// Each tab renders its feature's own "FlowView" (e.g. `HomeFlowView`),
/// which owns its own `AppRouter`/`NavigationStack`. This keeps each
/// tab's back-stack independent, so switching tabs never loses your
/// place in the other tab's navigation.
struct MainTabView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedTab: AppTab = .home
    
    @State private var isTabBarHidden: Bool = false
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                
                HomeFlowView()
                    .tag(AppTab.home)
                
                TodayStepsScreen()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(colorScheme == .light ? .white : Color.Teal.teal1600)
                    .tag(AppTab.calories)
                
                ScanFlowView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(colorScheme == .light ? .white : Color.Teal.teal1600)
                    .tag(AppTab.scan)
                
                ExerciseFlowView()
                    .tag(AppTab.bookmark)

                ProfileFlowView()
                    .tag(AppTab.profile)
            }
            .onPreferenceChange(HideTabBarKey.self) { hidden in
                withAnimation(.easeInOut(duration: 0.25)) {
                    isTabBarHidden = hidden
                }
            }
            
            if !isTabBarHidden {
                CustomAnimatedTabBar(selectedTab: $selectedTab)
                    .customTealShadow()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    MainTabView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    MainTabView()
        .preferredColorScheme(.dark)
}
