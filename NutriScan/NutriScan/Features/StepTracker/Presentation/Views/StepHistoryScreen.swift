import SwiftUI
import Charts

struct StepHistoryScreen: View {
    let viewModel: StepCounterViewModel
    @EnvironmentObject private var router: AppRouter
    @State private var selectedRange: StepHistoryRange = .lastWeek
    @State private var selectedIndex: Int = 0

    private var displayedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let calendar = Calendar.current
        guard let date = calendar.date(byAdding: .day, value: -selectedIndex, to: Date()) else {
            return ""
        }
        if selectedIndex == 0 {
            return "Today, \(formatter.string(from: date))"
        }
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }

    private var selectedDaySteps: Int {
        if selectedIndex == 0 {
            return viewModel.todaySteps
        }
        let calendar = Calendar.current
        guard let targetDate = calendar.date(byAdding: .day, value: -selectedIndex, to: Date()) else {
            return 0
        }
        let targetStart = calendar.startOfDay(for: targetDate)
        return viewModel.history.first(where: { calendar.isDate($0.date, inSameDayAs: targetStart) })?.stepCount ?? 0
    }

    private var weeklyAverage: Int {
        let weekData = viewModel.history.suffix(7)
        guard !weekData.isEmpty else { return 0 }
        return weekData.map(\.stepCount).reduce(0, +) / weekData.count
    }

    private var caloriesBurned: Int {
        Int(Double(selectedDaySteps) * 0.04)
    }

    private var distanceKm: Double {
        Double(selectedDaySteps) * 0.000762
    }

    private var activeMinutes: Int {
        selectedDaySteps / 100
    }

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
                BackButton {
                    router.pop()
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
            viewModel.loadHistory(range: selectedRange)
        }
        .onDisappear {
            viewModel.onDisappear()
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
                viewModel.loadHistory(range: newRange, forceRefresh: true)
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
                }
            },
            onNext: {
                withAnimation {
                    if selectedIndex > 0 { selectedIndex -= 1 }
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
            } else if viewModel.history.isEmpty {
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
        let displayData = Array(viewModel.history.suffix(displayDataCount))
        let maxStep = max(displayData.map(\.stepCount).max() ?? 1, 10_000)

        return VStack(spacing: 12) {
            Chart {
                ForEach(Array(displayData.enumerated()), id: \.offset) { _, day in
                    BarMark(
                        x: .value("Day", dayLabel(for: day.date)),
                        y: .value("Steps", day.stepCount)
                    )
                    .foregroundStyle(
                        day.stepCount >= 10_000
                            ? Color.Teal.teal600
                            : Color.Teal.teal400
                    )
                    .cornerRadius(6)
                    .annotation(position: .top, spacing: 4) {
                        Text("\(day.stepCount)")
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

    private var displayDataCount: Int {
        switch selectedRange {
        case .lastWeek: return 7
        case .lastMonth: return 30
        case .last3Months: return 30
        case .last6Months: return 30
        case .sinceYesterday: return 2
        }
    }

    private func dayLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        switch selectedRange {
        case .lastWeek, .sinceYesterday:
            formatter.dateFormat = "EEE"
        case .last3Months, .last6Months:
            formatter.dateFormat = "MMM d"
        default:
            formatter.dateFormat = "d"
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
                value: "\(caloriesBurned)",
                unit: "kcal"
            )

            StatCardView(
                icon: "mappin.circle.fill",
                iconColor: Color.Teal.teal1000,
                title: "Distance\nCovered",
                value: String(format: "%.1f", distanceKm),
                unit: "km"
            )

            StatCardView(
                icon: "stopwatch.fill",
                iconColor: Color.Teal.teal1000,
                title: "Active\nMinutes",
                value: "\(activeMinutes)",
                unit: "min"
            )
        }
    }
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
