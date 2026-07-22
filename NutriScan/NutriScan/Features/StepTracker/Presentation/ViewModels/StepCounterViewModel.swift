//
//  StepCounterViewModel.swift
//  StepTracker - Presentation / ViewModels
//

import Foundation
import Combine

@MainActor
final class StepCounterViewModel: ObservableObject {
    @Published private(set) var todaySteps: Int = 0
    @Published private(set) var isAuthorized: Bool = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var history: [DailySteps] = []
    @Published private(set) var isLoadingHistory: Bool = false

    private let observeStepsUseCase: ObserveDailyStepsUseCaseProtocol
    private let requestAuthUseCase: RequestStepAuthorizationUseCaseProtocol
    private let fetchHistoryUseCase: FetchStepsHistoryUseCaseProtocol
    private var observationTask: Task<Void, Never>?

    /// Cache of already-fetched history, keyed by range, so switching
    /// back to a previously selected range doesn't trigger a refetch.
    private var historyCache: [StepHistoryRange: [DailySteps]] = [:]

    init(
        observeStepsUseCase: ObserveDailyStepsUseCaseProtocol,
        requestAuthUseCase: RequestStepAuthorizationUseCaseProtocol,
        fetchHistoryUseCase: FetchStepsHistoryUseCaseProtocol
    ) {
        self.observeStepsUseCase = observeStepsUseCase
        self.requestAuthUseCase = requestAuthUseCase
        self.fetchHistoryUseCase = fetchHistoryUseCase
    }

    func onAppear() {
        Task {
            await requestAuthorizationAndObserve()
        }
    }

    func onDisappear() {
        observationTask?.cancel()
    }

    func loadHistory(range: StepHistoryRange, forceRefresh: Bool = false) {
        if !forceRefresh, let cached = historyCache[range] {
            history = cached
            return
        }
        Task {
            isLoadingHistory = true
            errorMessage = nil
            do {
                let result = try await fetchHistoryUseCase.execute(range: range)
                historyCache[range] = result
                history = result
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoadingHistory = false
        }
    }

    private func requestAuthorizationAndObserve() async {
        do {
            let granted = try await requestAuthUseCase.execute()
            print("🔵 StepTracker auth granted:", granted)
            isAuthorized = granted
            errorMessage = nil
            guard granted else {
                errorMessage = "Motion & Fitness access is required to count your steps."
                return
            }
            startObserving()
        } catch {
            print("🔴 StepTracker auth error:", error)
            errorMessage = error.localizedDescription
        }
    }

    private func startObserving() {
        observationTask?.cancel()
        observationTask = Task { [weak self] in
            guard let self else { return }
            for await steps in self.observeStepsUseCase.execute() {
                self.todaySteps = steps
            }
        }
    }
}
