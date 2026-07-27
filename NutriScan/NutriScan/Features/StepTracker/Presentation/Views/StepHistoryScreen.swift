import SwiftUI
import Charts

struct StepHistoryScreen: View {
    let viewModel: StepCounterViewModel
    @EnvironmentObject private var router: AppRouter
    @State private var selectedRange: StepHistoryRange = .lastWeek
    @State private var selectedIndex: Int = 0
    @State private var isFetching = false

    private var calendar: Calendar { Calendar.current }

    // MARK: - Date Range Computation

    private var rangeEndDate: Date {
        switch selectedRange {
        case .lastWeek, .sinceYesterday:
            return calendar.date(byAdding: .day, value: -selectedIndex, to: Date()) ?? Date()
        case .lastMonth:
            return calendar.date(byAdding: .day, value: -selectedIndex, to: Date()) ?? Date()
        case .last3Months, .last6Months:
            return calendar.date(byAdding: .month, value: -selectedIndex, to: Date()) ?? Date()
        }
    }

    private var rangeStartDate: Date {
        switch selectedRange {
        case .lastWeek:
            return calendar.date(byAdding: .day, value: -6, to: rangeEndDate) ?? rangeEndDate
        case .sinceYesterday:
            return calendar.date(byAdding: .day, value: -1, to: rangeEndDate) ?? rangeEndDate
        case .lastMonth:
            return calendar.date(byAdding: .day, value: -29, to: rangeEndDate) ?? rangeEndDate
        case .last3Months:
            return calendar.date(byAdding: .month, value: -3, to: rangeEndDate) ?? rangeEndDate
        case .last6Months:
            return calendar.date(byAdding: .month, value: -6, to: rangeEndDate) ?? rangeEndDate
        }
    }

    // MARK: - Displayed Date String

    private var displayedDate: String {
        let formatter = DateFormatter()
        switch selectedRange {
        case .lastWeek, .lastMonth, .sinceYesterday:
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEEE, MMM d"
            if selectedIndex == 0 {
                formatter.dateFormat = "MMM d"
                return "Today, \(formatter.string(from: rangeEndDate))"
            }
            return dayFormatter.string(from: rangeEndDate)
        case .last3Months, .last6Months:
            formatter.dateFormat = "MMM yyyy"
            return formatter.string(from: rangeEndDate)
        }
    }

    // MARK: - Chart Data Points (Aggregated)

    private var chartDataPoints: [ChartDataPoint] {
        let history = viewModel.history
        guard !history.isEmpty else { return [] }

        switch selectedRange {
        case .lastWeek, .sinceYesterday:
            // Daily points for week view
            return history.map { day in
                ChartDataPoint(
                    date: day.date,
                    steps: day.stepCount,
                    label: dayLabel(for: day.date)
                )
            }

        case .lastMonth:
            // Daily points for month view
            return history.map { day in
                ChartDataPoint(
                    date: day.date,
                    steps: day.stepCount,
                    label: dayLabel(for: day.date)
                )
            }

        case .last3Months, .last6Months:
            // Monthly aggregated points for 3M/6M views
            return aggregateByMonth(history)
        }
    }

    private func aggregateByMonth(_ history: [DailySteps]) -> [ChartDataPoint] {
        var monthly: [Date: Int] = [:]
        let calendar = Calendar.current

        for day in history {
            let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: day.date)) ?? day.date
            monthly[monthStart, default: 0] += day.stepCount
        }

        return monthly.sorted(by: { $0.key < $1.key }).map { (monthStart, totalSteps) in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            return ChartDataPoint(
                date: monthStart,
                steps: totalSteps,
                label: formatter.string(from: monthStart)
            )
        }
    }

    // MARK: - Selected Day Analytics

    private var selectedDaySteps: Int {
        if selectedIndex == 0 && (selectedRange == .lastWeek || selectedRange == .lastMonth || selectedRange == .sinceYesterday) {
            return viewModel.todaySteps
        }
        // Find the day in history that matches the rangeEndDate
        let targetStart = calendar.startOfDay(for: rangeEndDate)
        return viewModel.history.first { calendar.isDate($0.date, inSameDayAs: targetStart) }?.stepCount ?? 0
    }

    private var weeklyAverage: Int {
        let weekData = viewModel.history.suffix(7)
        guard !weekData.isEmpty else { return 0 }
        return weekData.map(\.stepCount).reduce(0, +) / weekData.count
    }

    private var selectedDayAnalytics: StepAnalytics {
        viewModel.analytics.compute(steps: selectedDaySteps)
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                rangeTabs
                dateNavigation
                DailyInsightCardView(
                    steps: selectedDaySteps,
                    goalSteps: 10_000,
                    weeklyAverage: weeklyAverage
                )
                stepHistoryChart
                bottomStatsRow
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .background(Color.StepTrackerSemantic.background.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton { router.pop() }
            }
        }
        .onAppear {
            viewModel.onAppear()
            fetchForCurrentSelection()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }

    // MARK: - Fetching

    private func fetchForCurrentSelection() {
        guard !isFetching else { return }
        isFetching = true
        viewModel.loadHistory(from: rangeStartDate, to: rangeEndDate, forceRefresh: true)
        // Reset fetch flag after a short delay to allow rapid navigation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isFetching = false
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        Text("Advanced Activity\nHistory Dashboard")
            .font(.custom("PlusJakartaSans-Bold", size: 28))
            .foregroundColor(Color.StepTrackerSemantic.chartTitle)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
    }

    // MARK: - Range Tabs

    private var rangeTabs: some View {
        RangePickerView(selectedRange: $selectedRange)
            .onChange(of: selectedRange) { _, newRange in
                selectedIndex = 0
                fetchForCurrentSelection()
            }
    }

    // MARK: - Date Navigation

    private var dateNavigation: some View {
        DateNavigationView(
            displayedDate: displayedDate,
            canGoForward: selectedIndex > 0,
            canGoBack: selectedIndex == 0,
            onPrevious: {
                withAnimation {
                    selectedIndex += 1
                    fetchForCurrentSelection()
                }
            },
            onNext: {
                withAnimation {
                    if selectedIndex > 0 {
                        selectedIndex -= 1
                        fetchForCurrentSelection()
                    }
                }
            }
        )
    }

    // MARK: - Step History Chart

    private var stepHistoryChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Step History")
                .font(.custom("PlusJakartaSans-SemiBold", size: 18))
                .foregroundColor(Color.StepTrackerSemantic.chartTitle)

            if viewModel.isLoadingHistory {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
            } else if chartDataPoints.isEmpty {
                emptyState
            } else {
                chart
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.StepTrackerSemantic.chartCardBackground)
                .customLightShadow()
        )
    }

    private var chart: some View {
        let data = chartDataPoints
        let maxStep = max(data.map(\.steps).max() ?? 1, 10_000)

        return VStack(spacing: 12) {
            Chart {
                ForEach(data) { point in
                    BarMark(
                        x: .value("Period", point.label),
                        y: .value("Steps", point.steps)
                    )
                    .foregroundStyle(
                        point.steps >= 10_000
                            ? Color.Teal.teal600
                            : Color.Teal.teal400
                    )
                    .cornerRadius(6)
                    .annotation(position: .top, spacing: 4) {
                        Text("\(point.steps.formatted())")
                            .font(.custom("LexendDeca-Regular", size: 10))
                            .foregroundColor(Color.StepTrackerSemantic.chartTitle)
                    }
                }

                RuleMark(y: .value("Goal", 10_000))
                    .foregroundStyle(Color.Teal.teal1000.opacity(0.3))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))
                    .annotation(position: .trailing, spacing: 4) {
                        Text("10,000")
                            .font(.custom("LexendDeca-Regular", size: 9))
                            .foregroundColor(Color.StepTrackerSemantic.insightSubtitle)
                    }
            }
            .chartYScale(domain: 0...max(maxStep, 12_000))
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisGridLine()
                        .foregroundStyle(Color.Gray.gray300.opacity(0.3))
                }
            }
            .chartXAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                        .font(.custom("LexendDeca-Regular", size: 11))
                        .foregroundStyle(Color.StepTrackerSemantic.axisText)
                }
            }
            .frame(height: 220)
        }
    }

    private func dayLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        switch selectedRange {
        case .lastWeek, .sinceYesterday:
            formatter.dateFormat = "EEE"
        case .lastMonth:
            formatter.dateFormat = "d"
        case .last3Months, .last6Months:
            formatter.dateFormat = "MMM"
        }
        return formatter.string(from: date)
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "chart.bar")
                .font(.system(size: 28))
                .foregroundColor(Color.Teal.teal400)
            Text("No step history yet")
                .font(.custom("LexendDeca-Regular", size: 14))
                .foregroundColor(Color.StepTrackerSemantic.axisText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }

    // MARK: - Bottom Stats Row

    private var bottomStatsRow: some View {
        HStack(spacing: 12) {
            StatCardView(
                icon: "flame.fill",
                iconColor: .orange,
                title: "Calories\nBurned",
                value: "\(selectedDayAnalytics.caloriesBurned)",
                unit: "kcal"
            )

            StatCardView(
                icon: "mappin.circle.fill",
                iconColor: Color.Teal.teal1000,
                title: "Distance\nCovered",
                value: String(format: "%.1f", selectedDayAnalytics.distanceKm),
                unit: "km"
            )

            StatCardView(
                icon: "stopwatch.fill",
                iconColor: Color.Teal.teal1000,
                title: "Active\nMinutes",
                value: "\(selectedDayAnalytics.activeMinutes)",
                unit: "min"
            )
        }
    }
}

// MARK: - Chart Data Point

private struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let steps: Int
    let label: String
}

#Preview {
    StepHistoryScreen(
        viewModel: StepCounterViewModel(
            observeStepsUseCase: DIContainer.shared.resolve(type: ObserveDailyStepsUseCase.self),
            requestAuthUseCase: DIContainer.shared.resolve(type: RequestStepAuthorizationUseCase.self),
            fetchHistoryUseCase: DIContainer.shared.resolve(type: FetchStepsHistoryUseCase.self)
        )
    )
    .environmentObject(AppRouter())
}