//
//  HomeView.swift
//  NutriScan
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator

    @State private var viewModel = HomeViewModel()
    @State private var showRAGChat = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                HomeGreetingSection(userName: viewModel.userName)
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
                    MenuRowView(icon: "bubble.left.and.bubble.right.fill", title: "Chat with AI") {
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
                        onViewAll: { },
                        onTap: { scanId in
                            router.push(HomeRoute.scanDetail(scanId: scanId))
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
        .onAppear {
            viewModel.loadHistory()
        }
        .fullScreenCover(isPresented: $showRAGChat) {
            RAGChatView(
                viewModel: RAGChatViewModel(
                    queryUseCase: DIContainer.shared.resolve(type: QueryRAGUseCase.self)
                )
            )
        }
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
