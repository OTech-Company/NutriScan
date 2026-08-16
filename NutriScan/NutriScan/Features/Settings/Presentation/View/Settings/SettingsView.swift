//
//  SettingsView.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
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

                    SettingsDeleteAccountButton {
                        viewModel.requestDeleteAccount()
                    }

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
            item: $viewModel.alert,
            config: { alert in
                switch alert {
                case .logout:
                    return CustomAlertConfig(
                        type: .warning,
                        title: "Logout",
                        message: "Are you sure you want to log out of NutriScan?",
                        primaryButton: CustomAlertButton("Logout", role: .destructive),
                        secondaryButton: CustomAlertButton("Cancel", role: .cancel)
                    )
                case .deleteAccount:
                    return CustomAlertConfig(
                        type: .delete,
                        title: "Delete Account",
                        message: "Are you sure you want to delete your account? You will have a 15-day grace period to restore it before permanent deletion.",
                        primaryButton: CustomAlertButton("Delete Account", role: .destructive),
                        secondaryButton: CustomAlertButton("Cancel", role: .cancel)
                    )
                }
            },
            primaryAction: { alert in
                switch alert {
                case .logout:
                    viewModel.confirmLogout(flowCoordinator: flowCoordinator)
                case .deleteAccount:
                    Task {
                        await viewModel.confirmDeleteAccount(flowCoordinator: flowCoordinator)
                    }
                }
            },
            secondaryAction: { alert in
                switch alert {
                case .logout: viewModel.cancelLogout()
                case .deleteAccount: viewModel.cancelDeleteAccount()
                }
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
