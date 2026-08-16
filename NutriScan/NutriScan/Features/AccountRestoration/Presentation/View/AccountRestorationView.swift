//
//  AccountRestorationView.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import SwiftUI

struct AccountRestorationView: View {
    private enum AlertDestination: String, Identifiable {
        case error
        var id: String { rawValue }
    }

    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator
    @State private var viewModel: AccountRestorationViewModel
    @State private var alert: AlertDestination?

    init(viewModel: AccountRestorationViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    private var formattedDateString: String {
        guard let date = flowCoordinator.pendingDeletionDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private var daysRemaining: Int? {
        guard let date = flowCoordinator.pendingDeletionDate else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: date)
        return max(0, (components.day ?? 0) + 1)
    }

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    // MARK: - Header
                    AccountRestorationHeaderSection()

                    // MARK: - Content
                    AccountRestorationContentSection(
                        daysRemaining: daysRemaining,
                        formattedDateString: formattedDateString
                    )
                    
                    // MARK: - Actions
                    AccountRestorationActionsSection(
                        isLoading: viewModel.isLoading,
                        onRestore: {
                            Task {
                                await viewModel.restoreAccount(flowCoordinator: flowCoordinator)
                            }
                        },
                        onLogout: {
                            viewModel.logout(flowCoordinator: flowCoordinator)
                        }
                    )
                    .padding(.top, 32)
                    .padding(.bottom, 40)
                }
            }
            .appAuthBackground()
            .navigationBarHidden(true)
            .ignoresSafeArea(edges: .top)
        }
        .onChange(of: viewModel.generalError) { _, error in
            if error != nil {
                alert = .error
            }
        }
        .customAlert(
            item: $alert,
            config: { _ in
                CustomAlertConfig(
                    type: .error,
                    title: LocalizationKeys.Auth.AccountRestoration.failedTitle.localized,
                    message: viewModel.generalError ?? LocalizationKeys.Common.unknownError.localized,
                    primaryButton: CustomAlertButton(LocalizationKeys.Common.tryAgain.localized)
                )
                )
            },
            primaryAction: { _ in viewModel.generalError = nil }
        )
    }
}

#Preview {
    AccountRestorationFactory.makeAccountRestorationView()
        .environmentObject(AppFlowCoordinator())
}
