//
//  StepCounterView.swift
//  StepTracker - Presentation / Views
//

import SwiftUI

struct StepCounterView: View {
    @StateObject private var viewModel: StepCounterViewModel
    @State private var selectedRange: StepHistoryRange = .lastWeek

    /// Default init wires up the real Data-layer implementation directly —
    /// no separate DI container needed.
    init() {
        let repository: StepRepositoryProtocol = StepRepositoryImpl()
        let viewModel = StepCounterViewModel(
            observeStepsUseCase: ObserveDailyStepsUseCase(repository: repository),
            requestAuthUseCase: RequestStepAuthorizationUseCase(repository: repository),
            fetchHistoryUseCase: FetchStepsHistoryUseCase(repository: repository)
        )
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    /// Use this init to inject a custom view model (e.g. with a mock
    /// repository) for previews or tests.
    init(viewModel: StepCounterViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 24) {
            Text("Today's Steps")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("\(viewModel.todaySteps)")
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .contentTransition(.numericText())
                .animation(.easeInOut, value: viewModel.todaySteps)

            Image(systemName: "figure.walk")
                .font(.system(size: 40))
                .foregroundColor(.blue)

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Picker("Range", selection: $selectedRange) {
                Text("Week").tag(StepHistoryRange.lastWeek)
                Text("Month").tag(StepHistoryRange.lastMonth)
                Text("3 Months").tag(StepHistoryRange.last3Months)
                Text("6 Months").tag(StepHistoryRange.last6Months)
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedRange) { _, newRange in
                viewModel.loadHistory(range: newRange)
            }

            if viewModel.isLoadingHistory {
                ProgressView()
            } else {
                List(viewModel.history, id: \.date) { day in
                    HStack {
                        Text(day.date, style: .date)
                        Spacer()
                        Text("\(day.stepCount)")
                    }
                }
                .listStyle(.plain)
            }
        }
        .padding()
        .onAppear {
            viewModel.onAppear()
            viewModel.loadHistory(range: selectedRange)
        }
        .onDisappear { viewModel.onDisappear() }
    }
}

#Preview {
    StepCounterView()
}
