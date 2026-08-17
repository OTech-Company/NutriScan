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

        VStack(spacing: 0) {
            SettingsHeaderSection {
                router.pop()
            }

            ScrollView(showsIndicators: false) {
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
            item: $viewModel.alert,
            config: { alert in
                switch alert {
                case .logout:
                    return CustomAlertConfig(
                        type: .warning,
                        title: LocalizationKeys.Settings.logoutAlertTitle.localized,
                        message: LocalizationKeys.Settings.logoutAlertDescription.localized,
                        primaryButton: CustomAlertButton(LocalizationKeys.Settings.logoutAlertConfirm.localized, role: .destructive),
                        secondaryButton: CustomAlertButton(LocalizationKeys.Common.cancel.localized, role: .cancel)
                    )
                case .deleteAccount:
                    return CustomAlertConfig(
                        type: .delete,
                        title: LocalizationKeys.Settings.deleteAlertTitle.localized,
                        message: LocalizationKeys.Settings.deleteAlertDescription.localized,
                        primaryButton: CustomAlertButton(LocalizationKeys.Settings.deleteAlertConfirm.localized, role: .destructive),
                        secondaryButton: CustomAlertButton(LocalizationKeys.Common.cancel.localized, role: .cancel)
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
