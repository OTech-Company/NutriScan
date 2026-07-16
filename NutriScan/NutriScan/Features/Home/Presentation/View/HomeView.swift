//
//  HomeView.swift
//  NutriScan
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: AppRouter

    @State private var viewModel = HomeViewModel()

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
        }
        .background(Color.HomeSemantic.homeBackground.ignoresSafeArea())
        .navigationBarHidden(true)
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
