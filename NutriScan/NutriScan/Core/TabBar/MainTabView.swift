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
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                
                HomeFlowView()
                    .tag(AppTab.home)
                
                Text("Calories Flow")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(colorScheme == .light ? .white : Color.Teal.teal1600)
                    .tag(AppTab.calories)
                
                Text("Scan Flow")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(colorScheme == .light ? .white : Color.Teal.teal1600)
                    .tag(AppTab.scan)
                
                Text("Bookmark Flow")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(colorScheme == .light ? .white : Color.Teal.teal1600)
                    .tag(AppTab.bookmark)

                ProfileFlowView()
                    .tag(AppTab.profile)
            }
            
            CustomAnimatedTabBar(selectedTab: $selectedTab)
                .customTealShadow()
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
