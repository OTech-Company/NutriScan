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
                        title: LocalizationKeys.Settings.profileSettings.localized,
                        action: {
                            router.push(SettingsRoute.profileSettings)
                        }
                    )

                    MenuRowView(
                        icon: "bell.badge.fill",
                        title: LocalizationKeys.Settings.notificationSettings.localized,
                        action: {
                            router.push(SettingsRoute.notificationSettings)
                        }
                    )

                    SettingsSegmentRow(
                        icon: "circle.lefthalf.filled",
                        title: LocalizationKeys.Settings.appearance.localized,
                        options: AppAppearance.allCases,
                        selected: $viewModel.selectedAppearance
                    )

                    SettingsSegmentRow(
                        icon: "globe",
                        title: LocalizationKeys.Settings.language.localized,
                        options: AppLanguage.allCases,
                        selected: $viewModel.selectedLanguage
                    )

                    MenuRowView(
                        icon: "questionmark.circle",
                        title: LocalizationKeys.Settings.terms.localized,
                        action: {
                            router.push(SettingsRoute.termsAndConditions)
                        }
                    )

                    MenuRowView(
                        icon: "questionmark.circle",
                        title: LocalizationKeys.Settings.help.localized,
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
            isPresented: $viewModel.showLogoutAlert,
            type: .warning,
            title: LocalizationKeys.Settings.logoutAlertTitle.localized,
            description: LocalizationKeys.Settings.logoutAlertDescription.localized,
            primaryButtonTitle: LocalizationKeys.Settings.logoutAlertConfirm.localized,
            primaryButtonColor: Color.Red.red500,
            primaryAction: {
                viewModel.confirmLogout(flowCoordinator: flowCoordinator)
            },
            secondaryButtonTitle: LocalizationKeys.Common.cancel.localized,
            secondaryAction: {
                viewModel.cancelLogout()
            }
        )
        .customAlert(
            isPresented: $viewModel.showDeleteAccountAlert,
            type: .warning,
            title: LocalizationKeys.Settings.deleteAlertTitle.localized,
            description: LocalizationKeys.Settings.deleteAlertDescription.localized,
            primaryButtonTitle: LocalizationKeys.Settings.deleteAlertConfirm.localized,
            primaryButtonColor: Color.Red.red500,
            primaryAction: {
                Task {
                    await viewModel.confirmDeleteAccount(flowCoordinator: flowCoordinator)
                }
            },
            secondaryButtonTitle: LocalizationKeys.Common.cancel.localized,
            secondaryAction: {
                viewModel.cancelDeleteAccount()
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
