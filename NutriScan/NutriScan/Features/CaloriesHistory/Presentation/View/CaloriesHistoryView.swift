//
//  CaloriesHistoryView.swift
//  NutriScan
//
//  Created by albaraa alsayed on 19/02/1448 AH.
//

import SwiftUI

struct CaloriesHistoryView: View {
    @EnvironmentObject private var router: AppRouter
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var isHeaderVisible = false
    @State private var isContentVisible = false

    let days: [DayUIState]
    let isLoading: Bool
    var onCalendarTap: () -> Void

    init(
        days: [DayUIState] = DayUIState.caloriesHistoryPreview,
        isLoading: Bool = false,
        onCalendarTap: @escaping () -> Void = {}
    ) {
        self.days = days
        self.isLoading = isLoading
        self.onCalendarTap = onCalendarTap
    }

    var body: some View {
        VStack(spacing: 0) {
            CaloriesHistoryHeader(
                onBackTap: { router.pop() },
                onCalendarTap: onCalendarTap
            )
            .padding(.horizontal, 22)
            .padding(.bottom, 16)
            .opacity(isHeaderVisible ? 1 : 0)
            .offset(y: reduceMotion || isHeaderVisible ? 0 : -8)
            .animation(headerAnimation, value: isHeaderVisible)

            ZStack {
                if isLoading {
                    shimmerList
                        .transition(.opacity)
                } else {
                    historyList
                        .transition(.opacity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(stateTransitionAnimation, value: isLoading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.CaloriesHistorySemantic.background.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: revealInitialContent)
        .onChange(of: isLoading) { _, loading in
            isContentVisible = !loading
        }
    }

    private var historyList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(days) { day in
                    CaloriesHistoryDayView(day: day)
                        .opacity(isContentVisible ? 1 : 0)
                        .offset(
                            y: reduceMotion || isContentVisible ? 0 : 18
                        )
                        .animation(
                            rowAnimation(for: day.id),
                            value: isContentVisible
                        )
                }
            }
            .padding(.bottom, 32)
            .padding(.horizontal, 22)
        }
    }

    private var shimmerList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(0..<4, id: \.self) { _ in
                    CaloriesHistoryDayShimmerView()
                }
            }
            .padding(.bottom, 32)
            .padding(.horizontal, 22)
        }
        .allowsHitTesting(false)
    }

    private var headerAnimation: Animation {
        .easeOut(duration: reduceMotion ? 0.15 : 0.32)
    }

    private var stateTransitionAnimation: Animation {
        .easeOut(duration: reduceMotion ? 0.15 : 0.25)
    }

    private func rowAnimation(for dayID: DayUIState.ID) -> Animation {
        guard !reduceMotion else {
            return .easeOut(duration: 0.15)
        }

        let index = days.firstIndex { $0.id == dayID } ?? 0
        let delay = min(Double(index) * 0.07, 0.35)
        return .spring(response: 0.46, dampingFraction: 0.84)
            .delay(delay)
    }

    private func revealInitialContent() {
        isHeaderVisible = true
        isContentVisible = !isLoading
    }
}

#Preview("Light") {
    CaloriesHistoryView()
        .environmentObject(AppRouter())
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    CaloriesHistoryView()
        .environmentObject(AppRouter())
        .preferredColorScheme(.dark)
}

#Preview("Loading Light") {
    CaloriesHistoryView(isLoading: true)
        .environmentObject(AppRouter())
        .preferredColorScheme(.light)
}

#Preview("Loading Dark") {
    CaloriesHistoryView(isLoading: true)
        .environmentObject(AppRouter())
        .preferredColorScheme(.dark)
}
