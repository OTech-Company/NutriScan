//
//  HomeView.swift
//  NutriScan
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator

    @State private var viewModel = HomeViewModel()
    @State private var recentHistoryNotifier = HomeRecentHistoryNotifier.shared
    @State private var showRAGChat = false
    @State private var activeAlert: ActiveAlert = .none
    @State private var recentScanPendingDeletion: UiStateHistoryItem?

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                HomeGreetingSection(
                    userName: viewModel.userName,
                    userImageURL: viewModel.userImageURL,
                    onProfileTap: {
                        flowCoordinator.selectedTab = .profile
                    },
                    onNotificationTap: {
                        router.push(SettingsRoute.notificationHistory)
                    }
                )
                .padding(.top, 22)

                HomeDailyTipSection(tipMessage: viewModel.dailyTip)
                    .padding(.top, 16)

                HomeReadyToScanSection {
                    flowCoordinator.selectedTab = .scan
                }

                ExploreSectionHeader()

                VStack {
                    MenuRowView(icon: "newspaper.fill", title: "Health News") {
                        router.push(HomeRoute.news)
                    }
                    MenuRowView(
                        icon: "bubble.left.and.bubble.right.fill",
                        title: "Chat with AI"
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
                            activeAlert = .delete
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
            Spacer(minLength: 60)
        }
        .background(Color.HomeSemantic.homeBackground.ignoresSafeArea())
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
                activeAlert = .error
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
            activeAlert: $activeAlert,
            config: { alert in
                switch alert {
                case .delete:
                    return CustomAlertConfig(
                        type: .delete,
                        title: "Delete Scan?",
                        description: "This scan will be removed from your history.",
                        primaryButtonTitle: "Delete",
                        primaryButtonColor: Color.Red.red500,
                        secondaryButtonTitle: "Cancel"
                    )
                case .error:
                    return CustomAlertConfig(
                        type: .error,
                        title: "Delete Failed",
                        description: viewModel.deleteErrorMessage ?? "Could not delete this scan.",
                        primaryButtonTitle: "OK",
                        primaryButtonColor: Color.Red.red500
                    )
                default:
                    return CustomAlertConfig(type: .warning, title: "Warning", description: "")
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
                default:
                    break
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
