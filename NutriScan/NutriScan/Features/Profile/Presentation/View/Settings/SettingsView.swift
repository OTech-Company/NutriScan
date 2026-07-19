//
//  SettingsView.swift
//  NutriScan
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var viewModel = SettingsViewModel()

    var body: some View {
        
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {

                SettingsHeaderSection {
                    router.pop()
                }

                VStack(spacing: 12) {
                    SettingsNavRow(
                        icon: "person.badge.shield.checkmark.fill",
                        title: "Profile Settings"
                    )

                    SettingsSegmentRow(
                        icon: "circle.lefthalf.filled",
                        title: "Appearance",
                        options: AppAppearance.allCases,
                        selected: $viewModel.selectedAppearance
                    )

                    SettingsSegmentRow(
                        icon: "globe",
                        title: "Language",
                        options: AppLanguage.allCases,
                        selected: $viewModel.selectedLanguage
                    )

                    SettingsNavRow(
                        icon: "questionmark.circle",
                        title: "Terms and Conditions"
                    )

                    SettingsNavRow(
                        icon: "questionmark.circle",
                        title: "Help"
                    )

                    SettingsLogoutButton {
                        viewModel.logout()
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 28)
                .padding(.bottom, 40)
            }
        }
        .background(Color.SettingsSemantic.screenBackground.ignoresSafeArea())
        .navigationBarHidden(true)
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(AppRouter())
    }
}
