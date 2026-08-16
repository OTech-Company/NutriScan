import Foundation
import Combine

@Observable
@MainActor
final class StepCounterViewModel {
    private(set) var todaySteps: Int = 0
    private(set) var isAuthorized: Bool = false
    private(set) var hasHealthKitReading: Bool = false
    private(set) var errorMessage: String?
    private(set) var history: [DailySteps] = []
    private(set) var isLoadingHistory: Bool = false

    var analytics: StepAnalyticsCalculator {
        StepAnalyticsCalculator(
            weightKg: profileService.weightKg ?? fallbackWeightKg,
            heightCm: profileService.heightCm ?? fallbackHeightCm
        )
    }

    private let observeStepsUseCase: ObserveDailyStepsUseCaseProtocol
    private let requestAuthUseCase: RequestStepAuthorizationUseCaseProtocol
    private let fetchHistoryUseCase: FetchStepsHistoryUseCaseProtocol
    private let profileService: UserProfileService
    private let fallbackWeightKg: Double
    private let fallbackHeightCm: Double
    private var observationTask: Task<Void, Never>?

    /// Full history fetched once (last 6 months), cached for slicing.
    private var fullHistoryCache: [DailySteps] = []
    private var hasFetchedFullHistory = false

    init(
        observeStepsUseCase: ObserveDailyStepsUseCaseProtocol,
        requestAuthUseCase: RequestStepAuthorizationUseCaseProtocol,
        fetchHistoryUseCase: FetchStepsHistoryUseCaseProtocol,
        profileService: UserProfileService = DIContainer.shared.resolve(type: UserProfileService.self),
        weightKg: Double = 70.0,
        heightCm: Double = 170.0
    ) {
        self.observeStepsUseCase = observeStepsUseCase
        self.requestAuthUseCase = requestAuthUseCase
        self.fetchHistoryUseCase = fetchHistoryUseCase
        self.profileService = profileService
        self.fallbackWeightKg = weightKg
        self.fallbackHeightCm = heightCm
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

    func rolloverToCurrentDay() {
        todaySteps = 0
        hasHealthKitReading = false
        if isAuthorized {
            startObserving()
        }
    }

    /// Fetches the full 6-month history once. Subsequent calls use the cache.
    func fetchFullHistoryIfNeeded() {
        guard !hasFetchedFullHistory else { return }
        Task {
            isLoadingHistory = true
            errorMessage = nil
            do {
                let calendar = Calendar.current
                let endDate = Date()
                let startDate = calendar.date(byAdding: .month, value: -6, to: endDate) ?? endDate
                let result = try await fetchHistoryUseCase.execute(from: startDate, to: endDate)
                fullHistoryCache = result
                hasFetchedFullHistory = true
                history = result
            } catch {
                if !isCancellation(error) {
                    errorMessage = error.localizedDescription
                }
            }
            isLoadingHistory = false
        }
    }

    /// Slices the cached full history for the given date range.
    func sliceHistory(from startDate: Date, to endDate: Date) -> [DailySteps] {
        let calendar = Calendar.current
        return fullHistoryCache.filter { day in
            day.date >= calendar.startOfDay(for: startDate) && day.date <= calendar.startOfDay(for: endDate)
        }
    }

    // MARK: - Legacy support (used by CaloriesScreen)

    func loadHistory(range: StepHistoryRange, forceRefresh: Bool = false) {
        fetchFullHistoryIfNeeded()
    }

    func loadHistory(from startDate: Date, to endDate: Date, forceRefresh: Bool = false) {
        fetchFullHistoryIfNeeded()
    }

    private func requestAuthorizationAndObserve() async {
        do {
            let granted = try await requestAuthUseCase.execute()
            print("🔵 StepTracker auth granted:", granted)
            isAuthorized = granted
            errorMessage = nil
            guard granted else {
                errorMessage = LocalizationKeys.Calories.permissionRequired.localized
                return
            }
            startObserving()
        } catch {
            guard !isCancellation(error) else { return }
            print("🔴 StepTracker auth error:", error)
            errorMessage = error.localizedDescription
        }
    }

    private func startObserving() {
        observationTask?.cancel()
        observationTask = Task { [weak self] in
            guard let self else { return }
            for await steps in self.observeStepsUseCase.execute() {
                self.hasHealthKitReading = true
                self.todaySteps = steps
            }
        }
    }

    private func isCancellation(_ error: Error) -> Bool {
        if error is CancellationError { return true }
        if let urlError = error as? URLError, urlError.code == .cancelled { return true }
        if case NetworkError.unknown(let wrappedError) = error {
            return isCancellation(wrappedError)
        }
        return false
    }
}
