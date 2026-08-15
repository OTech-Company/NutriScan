import SwiftUI
import Charts

struct StepHistoryScreen: View {
    let viewModel: StepCounterViewModel
    @EnvironmentObject private var router: AppRouter
    @State private var selectedRange: StepHistoryRange = .lastWeek
    @State private var displayedHistory: [DailySteps] = []

    private var calendar: Calendar { Calendar.current }

    // MARK: - Date Range Computation

    private var rangeEndDate: Date {
        Date()
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

    // MARK: - Date Strings

    private var startDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: rangeStartDate)
    }

    private var endDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: rangeEndDate)
    }

    // MARK: - Chart Data Points

    private var chartDataPoints: [ChartDataPoint] {
        guard !displayedHistory.isEmpty else { return [] }

        switch selectedRange {
        case .lastWeek, .sinceYesterday:
            return displayedHistory.map { day in
                ChartDataPoint(date: day.date, steps: day.stepCount, label: dayLabel(for: day.date))
            }
        case .lastMonth:
            return displayedHistory.map { day in
                ChartDataPoint(date: day.date, steps: day.stepCount, label: dayLabel(for: day.date))
            }
        case .last3Months, .last6Months:
            return aggregateByMonth(displayedHistory)
        }
    }

    private func aggregateByMonth(_ history: [DailySteps]) -> [ChartDataPoint] {
        var monthly: [Date: Int] = [:]
        for day in history {
            let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: day.date)) ?? day.date
            monthly[monthStart, default: 0] += day.stepCount
        }
        return monthly.sorted(by: { $0.key < $1.key }).map { (monthStart, totalSteps) in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            return ChartDataPoint(date: monthStart, steps: totalSteps, label: formatter.string(from: monthStart))
        }
    }

    // MARK: - Analytics

    private var periodTotalSteps: Int {
        displayedHistory.map(\.stepCount).reduce(0, +)
    }

    private var periodAverage: Int {
        guard !displayedHistory.isEmpty else { return 0 }
        return periodTotalSteps / displayedHistory.count
    }

    private var periodAnalytics: StepAnalytics {
        viewModel.analytics.compute(steps: periodTotalSteps)
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                BackButton { router.pop() }
                Text(LocalizationKeys.StepTracker.stepHistory.localized)
                    .font(.custom("LexendDeca-SemiBold", size: 18))
                    .foregroundColor(Color.StepTrackerSemantic.chartTitle)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 16)

            ScrollView {
                VStack(spacing: 20) {
                    rangeTabs
                    dateRangeCards
                    DailyInsightCardView(
                        steps: periodAverage,
                        goalSteps: 10_000,
                        weeklyAverage: periodAverage
                    )
                    stepHistoryChart
                    bottomStatsRow
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
        }
        .background(Color.StepTrackerSemantic.background.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.onAppear()
            viewModel.fetchFullHistoryIfNeeded()
            updateDisplayedHistory()
        }
        .onChange(of: selectedRange) { _, _ in
            updateDisplayedHistory()
        }
    }

    // MARK: - Slice cached data for the selected range

    private func updateDisplayedHistory() {
        displayedHistory = viewModel.sliceHistory(from: rangeStartDate, to: rangeEndDate)
    }

    // MARK: - Range Tabs

    private var rangeTabs: some View {
        RangePickerView(selectedRange: $selectedRange)
    }

    // MARK: - Date Range Cards (Start / End)

    private var dateRangeCards: some View {
        HStack(spacing: 12) {
            dateCard(label: LocalizationKeys.StepTracker.start.localized, date: startDateString)
            dateCard(label: LocalizationKeys.StepTracker.end.localized, date: endDateString)
        }
    }

    private func dateCard(label: String, date: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .font(.system(size: 14))
                    .foregroundColor(Color.Teal.teal1000)
                Text(label)
                    .font(.custom("LexendDeca-Regular", size: 13))
                    .foregroundColor(Color.StepTrackerSemantic.insightSubtitle)
            }
            Text(date)
                .font(.custom("PlusJakartaSans-SemiBold", size: 18))
                .foregroundColor(Color.StepTrackerSemantic.chartTitle)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.StepTrackerSemantic.chartCardBackground)
                .customLightShadow()
        )
    }

    // MARK: - Step History Chart

    private var stepHistoryChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(LocalizationKeys.StepTracker.stepHistory.localized)
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
                        x: .value(LocalizationKeys.StepTracker.period.localized, point.label),
                        y: .value(LocalizationKeys.StepTracker.steps.localized, point.steps)
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

                RuleMark(y: .value(LocalizationKeys.StepTracker.goal.localized, 10_000))
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
            Text(LocalizationKeys.StepTracker.noHistory.localized)
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
                title: LocalizationKeys.StepTracker.caloriesBurned.localized,
                value: "\(periodAnalytics.caloriesBurned)",
                unit: "kcal"
            )

            StatCardView(
                icon: "mappin.circle.fill",
                iconColor: Color.Teal.teal1000,
                title: LocalizationKeys.StepTracker.distanceCovered.localized,
                value: String(format: "%.1f", periodAnalytics.distanceKm),
                unit: "km"
            )

            StatCardView(
                icon: "stopwatch.fill",
                iconColor: Color.Teal.teal1000,
                title: LocalizationKeys.StepTracker.activeMinutes.localized,
                value: "\(periodAnalytics.activeMinutes)",
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
