//
//  CaloriesHistoryView.swift
//  NutriScan
//
//  Created by albaraa alsayed on 19/02/1448 AH.
//

import SwiftUI

struct CaloriesHistoryView: View {
    @EnvironmentObject private var router: AppRouter

    let days: [DayUIState]
    var onCalendarTap: () -> Void

    init(
        days: [DayUIState] = DayUIState.caloriesHistoryPreview,
        onCalendarTap: @escaping () -> Void = {}
    ) {
        self.days = days
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

            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    ForEach(days) { day in
                        CaloriesHistoryDayView(day: day)
                    }
                }
                .padding(.bottom, 32)
                .padding(.horizontal, 22)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.CaloriesHistorySemantic.background.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
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

