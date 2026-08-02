//
//  SettingsView.swift
//  NutriScan
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator
    @State private var viewModel: SettingsViewModel

    init(viewModel: SettingsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {

        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {

                SettingsHeaderSection {
                    router.pop()
                }

                VStack(spacing: 12) {
                    MenuRowView(
                        icon: "person.badge.shield.checkmark.fill",
                        title: "Profile Settings",
                        action: {
                            router.push(SettingsRoute.profileSettings)
                        }
                    )
                    
                    MenuRowView(
                        icon: "bell.badge.fill",
                        title: "Notification Settings",
                        action: {
                            router.push(SettingsRoute.notificationSettings)
                        }
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

                    MenuRowView(
                        icon: "questionmark.circle",
                        title: "Terms and Conditions",
                        action: {
                            router.push(SettingsRoute.termsAndConditions)
                        }
                    )

                    MenuRowView(
                        icon: "questionmark.circle",
                        title: "Help",
                        action: {
                            router.push(SettingsRoute.help)
                        }
                    )

                    SettingsLogoutButton {
                        viewModel.requestLogout()
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
        .customAlert(
            isPresented: $viewModel.showLogoutAlert,
            type: .warning,
            title: "Logout",
            description: "Are you sure you want to log out of NutriScan?",
            primaryButtonTitle: "Logout",
            primaryButtonColor: Color.Red.red500,
            primaryAction: {
                viewModel.confirmLogout(flowCoordinator: flowCoordinator)
            },
            secondaryButtonTitle: "Cancel",
            secondaryAction: {
                viewModel.cancelLogout()
            }
        )
    }
}

#Preview {
    NavigationStack {
        SettingsFactory.makeSettingsView()
            .environmentObject(AppRouter())
    }
}
