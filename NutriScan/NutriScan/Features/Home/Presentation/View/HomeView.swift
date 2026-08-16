//
//  HomeView.swift
//  NutriScan
//

import SwiftUI

struct HomeView: View {
    private enum AlertDestination: String, Identifiable {
        case delete
        case error
        var id: String { rawValue }
    }

    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator

    @State private var viewModel = HomeViewModel()
    @State private var recentHistoryNotifier = HomeRecentHistoryNotifier.shared
    @State private var showRAGChat = false
    @State private var alert: AlertDestination?
    @State private var recentScanPendingDeletion: UiStateHistoryItem?

    var body: some View {
        TopSafeAreaScrollView(
            background: Color.HomeSemantic.homeBackground,
            topBar: { phase in
                HomeGreetingSection(
                    userName: viewModel.userName,
                    userImageURL: viewModel.userImageURL,
                    collapseProgress: phase.progress,
                    onProfileTap: {
                        flowCoordinator.selectedTab = .profile
                    },
                    onNotificationTap: {
                        router.push(SettingsRoute.notificationHistory)
                    }
                )
                .padding(.horizontal, 20)
                .frame(height: 68)
                .accessibilityIdentifier("home.topBar")
            }
        ) {
            VStack(spacing: 20) {
                HomeDailyTipSection(tipMessage: viewModel.dailyTip)
                    .padding(.top, 16)

                HomeReadyToScanSection {
                    flowCoordinator.selectedTab = .scan
                }

                ExploreSectionHeader()

                VStack {
                    MenuRowView(icon: "newspaper.fill", title: LocalizationKeys.Home.healthNews.localized) {
                        router.push(HomeRoute.news)
                    }
                    MenuRowView(
                        icon: "bubble.left.and.bubble.right.fill",
                        title: LocalizationKeys.Home.chatWithAI.localized
                    ) {
                        showRAGChat = true
                    }
                }

                if viewModel.isLoadingHistory {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                } else {
                    RecentHistoryView(
                        historyItems: viewModel.recentHistory,
                        onViewAll: {
                            router.push(HomeRoute.scanHistory)
                        },
                        onTap: { scanId in
                            router.push(HomeRoute.scanDetail(scanId: scanId))
                        },
                        onRequestDelete: { item in
                            recentScanPendingDeletion = item
                            alert = .delete
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
            Spacer(minLength: CustomAnimatedTabBar.contentClearance)
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.loadHistoryIfNeeded()
        }
        .onChange(of: recentHistoryNotifier.refreshToken) {
            Task {
                await viewModel.refreshHistory()
            }
        }
        .onChange(of: viewModel.deleteErrorMessage) { _, message in
            if message != nil {
                alert = .error
            }
        }
        .fullScreenCover(isPresented: $showRAGChat) {
            RAGChatView(
                viewModel: RAGChatViewModel(
                    queryUseCase: DIContainer.shared.resolve(
                        type: QueryRAGUseCase.self)
                )
            )
        }
        .customAlert(
            item: $alert,
            config: { alert in
                switch alert {
                case .delete:
                    return CustomAlertConfig(
                        type: .delete,
                        title: LocalizationKeys.Home.deleteScanTitle.localized,
                        message: LocalizationKeys.Home.deleteScanDesc.localized,
                        primaryButton: CustomAlertButton(LocalizationKeys.Common.delete.localized, role: .destructive),
                        secondaryButton: CustomAlertButton(LocalizationKeys.Common.cancel.localized, role: .cancel)
                    )
                case .error:
                    return CustomAlertConfig(
                        type: .error,
                        title: LocalizationKeys.Home.deleteFailedTitle.localized,
                        message: viewModel.deleteErrorMessage ?? LocalizationKeys.Common.unknownError.localized,
                        primaryButton: CustomAlertButton(LocalizationKeys.Common.ok.localized, role: .destructive)
                    )
                }
            },
            primaryAction: { alert in
                switch alert {
                case .delete:
                    guard let item = recentScanPendingDeletion else { return }
                    Task {
                        await viewModel.deleteRecentScan(item)
                        recentScanPendingDeletion = nil
                    }
                case .error:
                    viewModel.deleteErrorMessage = nil
                }
            },
            secondaryAction: { alert in
                if alert == .delete {
                    recentScanPendingDeletion = nil
                }
            }
        )
    }
}

#Preview("Light") {
    HomeView()
        .environmentObject(AppRouter())
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    HomeView()
        .environmentObject(AppRouter())
        .preferredColorScheme(.dark)
}
