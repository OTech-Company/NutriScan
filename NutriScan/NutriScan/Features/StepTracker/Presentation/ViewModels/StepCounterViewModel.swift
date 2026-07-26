import Foundation
import Combine

@Observable
@MainActor
final class StepCounterViewModel {
    private(set) var todaySteps: Int = 0
    private(set) var isAuthorized: Bool = false
    private(set) var errorMessage: String?
    private(set) var history: [DailySteps] = []
    private(set) var isLoadingHistory: Bool = false

    let analytics: StepAnalyticsCalculator

    private let observeStepsUseCase: ObserveDailyStepsUseCaseProtocol
    private let requestAuthUseCase: RequestStepAuthorizationUseCaseProtocol
    private let fetchHistoryUseCase: FetchStepsHistoryUseCaseProtocol
    private var observationTask: Task<Void, Never>?

    private var historyCache: [StepHistoryRange: [DailySteps]] = [:]
    private var customRangeCache: String = ""

    init(
        observeStepsUseCase: ObserveDailyStepsUseCaseProtocol,
        requestAuthUseCase: RequestStepAuthorizationUseCaseProtocol,
        fetchHistoryUseCase: FetchStepsHistoryUseCaseProtocol,
        weightKg: Double = 70.0,
        heightCm: Double = 170.0
    ) {
        self.observeStepsUseCase = observeStepsUseCase
        self.requestAuthUseCase = requestAuthUseCase
        self.fetchHistoryUseCase = fetchHistoryUseCase
        self.analytics = StepAnalyticsCalculator(weightKg: weightKg, heightCm: heightCm)
    }

    func todayAnalytics() -> StepAnalytics {
        analytics.compute(steps: todaySteps)
    }

    func analytics(for steps: Int) -> StepAnalytics {
        analytics.compute(steps: steps)
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

    func loadHistory(from startDate: Date, to endDate: Date, forceRefresh: Bool = false) {
        let calendar = Calendar.current
        let startKey = calendar.startOfDay(for: startDate)
        let cacheKey = "\(startKey.timeIntervalSince1970)_\(endDate.timeIntervalSince1970)"

        if !forceRefresh, customRangeCache == cacheKey, !history.isEmpty {
            return
        }
        Task {
            isLoadingHistory = true
            errorMessage = nil
            do {
                let result = try await fetchHistoryUseCase.execute(from: startDate, to: endDate)
                customRangeCache = cacheKey
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
