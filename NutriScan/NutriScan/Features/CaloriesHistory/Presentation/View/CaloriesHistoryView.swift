//
//  CaloriesHistoryView.swift
//  NutriScan
//
//  Created by albaraa alsayed on 19/02/1448 AH.
//

import SwiftUI

struct CaloriesHistoryView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var viewModel: CaloriesHistoryViewModel
    @State private var networkMonitor: NetworkMonitor
    @State private var isHeaderVisible = false
    @State private var isContentVisible = false
    @State private var dateFilterPresentation: DateFilterPresentation?
    @State private var hasHandledInitialConnectivity = false

    init(
        viewModel: CaloriesHistoryViewModel,
        networkMonitor: NetworkMonitor = .shared
    ) {
        _viewModel = State(initialValue: viewModel)
        _networkMonitor = State(initialValue: networkMonitor)
    }

    var body: some View {
        VStack(spacing: 0) {
            CaloriesHistoryHeader(
                onBackTap: { router.pop() },
                onCalendarTap: presentDateFilter
            )
            .padding(.horizontal, 22)
            .padding(.bottom, 16)
            .opacity(isHeaderVisible ? 1 : 0)
            .offset(y: reduceMotion || isHeaderVisible ? 0 : -8)
            .animation(headerAnimation, value: isHeaderVisible)

            if viewModel.isFiltered {
                HStack {
                    CaloriesHistoryFilterChip(
                        label: viewModel.selectedDateLabel,
                        onRemove: {
                            Task { await viewModel.removeDateFilter() }
                        }
                    )
                    Spacer()
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 12)
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            ZStack { stateContent }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(stateTransitionAnimation, value: contentState)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.CaloriesHistorySemantic.background.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: revealInitialContent)
        .onChange(of: viewModel.isLoadingInitial) { _, loading in
            isContentVisible = !loading
        }
        .task(id: networkMonitor.isConnected) {
            let isReconnect = hasHandledInitialConnectivity
            hasHandledInitialConnectivity = true

            if isReconnect, networkMonitor.isConnected {
                await viewModel.retryAfterConnectionRestored()
            } else {
                await viewModel.loadIfConnected(networkMonitor.isConnected)
            }
        }
        .sheet(item: $dateFilterPresentation) { presentation in
            CaloriesHistoryDateFilterSheet(initialDate: presentation.initialDate) { date in
                Task { await viewModel.applyDateFilter(date) }
            }
        }
    }

    @ViewBuilder
    private var stateContent: some View {
        switch contentState {
        case .noConnection:
            EmptyStateView(emptyState: .noConnection) {
                Task { await viewModel.retryInitialLoad() }
            }
            .transition(.opacity)
        case .loading:
            shimmerList
                .transition(.opacity)
        case .serverProblem:
            EmptyStateView(emptyState: .serverProblem) {
                Task { await viewModel.retryInitialLoad() }
            }
            .transition(.opacity)
        case .noCaloriesHistory:
            EmptyStateView(emptyState: .noCaloriesHistory) {
                navigateToSavedTab()
            }
            .transition(.opacity)
        case .history:
            historyList
                .transition(.opacity)
        }
    }

    private var contentState: CaloriesHistoryContentState {
        CaloriesHistoryContentState.resolve(
            hasDays: !viewModel.days.isEmpty,
            isConnected: networkMonitor.isConnected,
            isLoading: viewModel.isLoadingInitial,
            hasError: viewModel.initialLoadError != nil
        )
    }

    private var historyList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.days) { day in
                    CaloriesHistoryDayView(day: day)
                        .opacity(isContentVisible ? 1 : 0)
                        .offset(
                            y: reduceMotion || isContentVisible ? 0 : 18
                        )
                        .animation(
                            rowAnimation(for: day.id),
                            value: isContentVisible
                        )
                        .onAppear {
                            Task {
                                await viewModel.loadNextPageIfNeeded(currentDayID: day.id)
                            }
                        }
                }

                if viewModel.isLoadingNextPage {
                    ProgressView()
                        .tint(Color.Teal.teal1000)
                        .padding(.vertical, 12)
                } else if viewModel.paginationError != nil {
                    PaginationRetryFooter {
                        Task { await viewModel.retryPagination() }
                    }
                }
            }
            .padding(.bottom, 32)
            .padding(.horizontal, 22)
        }
        .refreshable {
            await viewModel.refresh()
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

        let index = viewModel.days.firstIndex { $0.id == dayID } ?? 0
        let delay = min(Double(index) * 0.07, 0.35)
        return .spring(response: 0.46, dampingFraction: 0.84)
            .delay(delay)
    }

    private func revealInitialContent() {
        isHeaderVisible = true
        isContentVisible = !viewModel.isLoadingInitial
    }

    private func presentDateFilter() {
        dateFilterPresentation = DateFilterPresentation(
            initialDate: viewModel.selectedDate ?? Date()
        )
    }

    private func navigateToSavedTab() {
        CaloriesHistoryNavigation.showSaved(
            router: router,
            flowCoordinator: flowCoordinator
        )
    }
}

@MainActor
enum CaloriesHistoryNavigation {
    static func showSaved(
        router: AppRouter,
        flowCoordinator: AppFlowCoordinator
    ) {
        router.popToRoot()
        flowCoordinator.selectedTab = .bookmark
    }
}

enum CaloriesHistoryContentState: Equatable {
    case noConnection
    case loading
    case serverProblem
    case noCaloriesHistory
    case history

    static func resolve(
        hasDays: Bool,
        isConnected: Bool,
        isLoading: Bool,
        hasError: Bool
    ) -> CaloriesHistoryContentState {
        if !hasDays, !isConnected {
            return .noConnection
        }
        if isLoading {
            return .loading
        }
        if !hasDays, hasError {
            return .serverProblem
        }
        return hasDays ? .history : .noCaloriesHistory
    }
}

private struct DateFilterPresentation: Identifiable {
    let id = UUID()
    let initialDate: Date
}

#Preview("Calories History Light") {
    CaloriesHistoryView(viewModel: caloriesHistoryPreviewViewModel())
        .environmentObject(AppRouter())
        .environmentObject(caloriesHistoryPreviewCoordinator())
        .preferredColorScheme(.light)
}

#Preview("Calories History Dark") {
    CaloriesHistoryView(viewModel: caloriesHistoryPreviewViewModel())
        .environmentObject(AppRouter())
        .environmentObject(caloriesHistoryPreviewCoordinator())
        .preferredColorScheme(.dark)
}

@MainActor
private func caloriesHistoryPreviewViewModel() -> CaloriesHistoryViewModel {
    CaloriesHistoryViewModel(
        getPageUseCase: CaloriesHistoryPreviewPageUseCase(),
        getByDateUseCase: CaloriesHistoryPreviewDateUseCase()
    )
}

private struct CaloriesHistoryPreviewPageUseCase: GetCaloriesHistoryPageUseCaseProtocol {
    func execute(page: Int, size: Int) async throws -> CaloriesHistoryPage {
        CaloriesHistoryPage(
            days: CaloriesHistoryPreviewData.days,
            totalElements: CaloriesHistoryPreviewData.days.count,
            totalPages: 1,
            currentPage: page,
            pageSize: size,
            numberOfElements: CaloriesHistoryPreviewData.days.count,
            isFirst: true,
            isLast: true
        )
    }
}

private struct CaloriesHistoryPreviewDateUseCase: GetCaloriesHistoryByDateUseCaseProtocol {
    func execute(date: Date) async throws -> CaloriesHistoryDay {
        CaloriesHistoryPreviewData.days[0]
    }
}

private enum CaloriesHistoryPreviewData {
    static let days: [CaloriesHistoryDay] = [
        day(
            id: 1,
            daysAgo: 0,
            water: 7,
            steps: 10_000,
            stepCalories: 415,
            exerciseCalories: 260,
            exerciseMinutes: 46,
            mealCalories: 2_400,
            mealCount: 3
        ),
        day(
            id: 2,
            daysAgo: 1,
            water: 8,
            steps: 8_450,
            stepCalories: 350,
            exerciseCalories: 210,
            exerciseMinutes: 35,
            mealCalories: 1_850,
            mealCount: 3
        ),
        day(
            id: 3,
            daysAgo: 2,
            water: 6,
            steps: 7_230,
            stepCalories: 298,
            exerciseCalories: 180,
            exerciseMinutes: 30,
            mealCalories: 2_100,
            mealCount: 4
        ),
        day(
            id: 4,
            daysAgo: 3,
            water: 5,
            steps: 6_800,
            stepCalories: 275,
            exerciseCalories: 145,
            exerciseMinutes: 24,
            mealCalories: 1_975,
            mealCount: 3
        )
    ]

    private static func day(
        id: Int,
        daysAgo: Int,
        water: Int,
        steps: Int,
        stepCalories: Double,
        exerciseCalories: Double,
        exerciseMinutes: Double,
        mealCalories: Int,
        mealCount: Int
    ) -> CaloriesHistoryDay {
        CaloriesHistoryDay(
            id: id,
            date: Calendar.current.date(
                byAdding: .day,
                value: -daysAgo,
                to: Date()
            ) ?? Date(),
            targetWaterCount: 8,
            waterCount: water,
            stepCount: steps,
            stepCalories: stepCalories,
            exerciseCalories: exerciseCalories,
            exerciseMinutes: exerciseMinutes,
            totalMealCalories: mealCalories,
            mealCount: mealCount,
            meals: []
        )
    }
}

private struct CaloriesHistoryPreviewProfileUseCase: FetchAndCacheProfileUseCaseProtocol {
    func execute() async throws {}
}

@MainActor
private func caloriesHistoryPreviewCoordinator() -> AppFlowCoordinator {
    AppFlowCoordinator(
        fetchAndCacheProfileUseCase: CaloriesHistoryPreviewProfileUseCase()
    )
}
