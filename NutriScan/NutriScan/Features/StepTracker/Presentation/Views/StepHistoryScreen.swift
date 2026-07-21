//
//  StepHistoryScreen.swift
//  NutriScan
//
//  Created by Osama Hosam on 22/07/2026.
//

import SwiftUI

struct StepHistoryScreen: View {
    @ObservedObject var viewModel: StepCounterViewModel
    @State private var selectedRange: StepHistoryRange = .lastWeek

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Picker("Range", selection: $selectedRange) {
                    Text("Week").tag(StepHistoryRange.lastWeek)
                    Text("Month").tag(StepHistoryRange.lastMonth)
                    Text("3 Months").tag(StepHistoryRange.last3Months)
                    Text("6 Months").tag(StepHistoryRange.last6Months)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .onChange(of: selectedRange) { _, newRange in
                    viewModel.loadHistory(range: newRange)
                }

                if viewModel.isLoadingHistory {
                    ProgressView()
                        .frame(maxHeight: .infinity)
                } else {
                    StepHistoryBarChartView(history: viewModel.history, goalSteps: 10_000)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.top)
        }
        .onAppear {
            viewModel.loadHistory(range: selectedRange)
        }
    }
}

#Preview {
    StepHistoryScreen(
        viewModel: StepCounterViewModel(
            observeStepsUseCase: ObserveDailyStepsUseCase(repository: StepRepositoryImpl()),
            requestAuthUseCase: RequestStepAuthorizationUseCase(repository: StepRepositoryImpl()),
            fetchHistoryUseCase: FetchStepsHistoryUseCase(repository: StepRepositoryImpl())
        )
    )
}
