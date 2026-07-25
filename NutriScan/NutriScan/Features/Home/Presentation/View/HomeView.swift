//
//  HomeView.swift
//  NutriScan
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: AppRouter

    @State private var viewModel = HomeViewModel()
    @State private var showRAGChat = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // MARK: Greeting
                HomeGreetingSection(userName: viewModel.userName)
                    .padding(.top, 22)

                // MARK: Daily Tip
                HomeDailyTipSection(tipMessage: viewModel.dailyTip)
                    .padding(.top,16)

                // MARK: Scan CTA
                HomeReadyToScanSection {
                    // TODO: Navigate to scanner screen
                }
                
                
                ExploreSectionHeader()
                
                VStack {
                    SettingsNavRow(icon: "newspaper.fill", title: "Health News") {
                        // Add action when news button pressed
                    }
                    SettingsNavRow(icon: "bubble.left.and.bubble.right.fill", title: "Chat with AI") {
                        showRAGChat = true
                    }
                }

                // MARK: Recent History
                RecentHistoryView(
                    historyItems: viewModel.recentHistory,
                    onViewAll: {
                        // TODO: Navigate to full history
                    }
                )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
            Spacer(minLength: 60)
        }
        .background(Color.HomeSemantic.homeBackground.ignoresSafeArea())
        .navigationBarHidden(true)
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
