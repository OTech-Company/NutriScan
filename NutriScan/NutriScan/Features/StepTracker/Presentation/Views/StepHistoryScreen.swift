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

    private var weeklyAverage: Int {
        let weekData = viewModel.history.suffix(7)
        guard !weekData.isEmpty else { return 0 }
        return weekData.map(\.stepCount).reduce(0, +) / weekData.count
    }

    private var todaySteps: Int {
        viewModel.history.last?.stepCount ?? 0
    }

    private var caloriesBurned: Int {
        Int(Double(todaySteps) * 0.04)
    }

    private var distanceKm: Double {
        Double(todaySteps) * 0.000762
    }

    private var activeMinutes: Int {
        todaySteps / 100
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                rangeTabs
                dateNavigation
                dailyInsightCard
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
            viewModel.loadHistory(range: selectedRange)
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
        HStack(spacing: 12) {
            tabButton(title: "Week", range: .lastWeek)
            tabButton(title: "Month", range: .lastMonth)
            tabButton(title: "3 Months", range: .last3Months)
            tabButton(title: "6 Months", range: .last6Months)
        }
    }

    private func tabButton(title: String, range: StepHistoryRange) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                selectedRange = range
                selectedIndex = 0
            }
            viewModel.loadHistory(range: range)
        } label: {
            Text(title)
                .font(.custom("LexendDeca-Medium", size: 13))
                .foregroundColor(selectedRange == range ? .white : Color.StepTrackerSemantic.tabUnselected)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(selectedRange == range ? Color.Teal.teal1000 : Color.StepTrackerSemantic.tabBackground)
                )
        }
    }

    // MARK: - Date Navigation

    private var dateNavigation: some View {
        HStack {
            Button {
                withAnimation {
                    selectedIndex += 1
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.StepTrackerSemantic.chartTitle)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(Color.StepTrackerSemantic.navArrowBackground)
                    )
            }
            .disabled(selectedIndex == 0)
            .opacity(selectedIndex == 0 ? 0.4 : 1)

            Spacer()

            Text(displayedDate)
                .font(.custom("PlusJakartaSans-SemiBold", size: 17))
                .foregroundColor(Color.StepTrackerSemantic.chartTitle)

            Spacer()

            Button {
                withAnimation {
                    if selectedIndex > 0 { selectedIndex -= 1 }
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.StepTrackerSemantic.chartTitle)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(Color.StepTrackerSemantic.navArrowBackground)
                    )
            }
            .disabled(selectedIndex == 0)
            .opacity(selectedIndex == 0 ? 0.4 : 1)
        }
        .padding(.horizontal, 4)
    }

    // MARK: - Daily Insight Card

    private var dailyInsightCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Daily Insight")
                .font(.custom("PlusJakartaSans-SemiBold", size: 18))
                .foregroundColor(Color.StepTrackerSemantic.chartTitle)

            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(Color.Teal.teal200, lineWidth: 5)
                        .frame(width: 56, height: 56)

                    Circle()
                        .trim(from: 0, to: min(Double(todaySteps) / 10_000, 1.0))
                        .stroke(Color.Teal.teal1000, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                        .frame(width: 56, height: 56)
                        .rotationEffect(.degrees(-90))

                    Image(systemName: "figure.walk")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color.Teal.teal1000)
                }

                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(todaySteps.formatted())")
                            .font(.custom("PlusJakartaSans-Bold", size: 24))
                            .foregroundColor(Color.Teal.teal1000)
                        Text("Steps")
                            .font(.custom("LexendDeca-Regular", size: 14))
                            .foregroundColor(Color.StepTrackerSemantic.insightSubtitle)
                    }
                    Text("of 10,000 Goal")
                        .font(.custom("LexendDeca-Regular", size: 13))
                        .foregroundColor(Color.StepTrackerSemantic.insightSubtitle)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("Weekly Average")
                        .font(.custom("LexendDeca-Regular", size: 12))
                        .foregroundColor(Color.StepTrackerSemantic.insightSubtitle)
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(weeklyAverage.formatted())")
                            .font(.custom("PlusJakartaSans-Bold", size: 20))
                            .foregroundColor(Color.StepTrackerSemantic.chartTitle)
                        Text("Steps")
                            .font(.custom("LexendDeca-Regular", size: 12))
                            .foregroundColor(Color.StepTrackerSemantic.insightSubtitle)
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.StepTrackerSemantic.weeklyAvgBackground)
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.StepTrackerSemantic.chartCardBackground)
                .customLightShadow()
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
        let displayData = Array(viewModel.history.suffix(7))
        let maxStep = max(displayData.map(\.stepCount).max() ?? 1, 10_000)

        return VStack(spacing: 12) {
            Chart {
                ForEach(Array(displayData.enumerated()), id: \.offset) { index, day in
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

    private func dayLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
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
            statCard(
                icon: "flame.fill",
                iconColor: .orange,
                title: "Calories\nBurned",
                value: "\(caloriesBurned)",
                unit: "kcal"
            )

            statCard(
                icon: "mappin.circle.fill",
                iconColor: Color.Teal.teal1000,
                title: "Distance\nCovered",
                value: String(format: "%.1f", distanceKm),
                unit: "km"
            )

            statCard(
                icon: "stopwatch.fill",
                iconColor: Color.Teal.teal1000,
                title: "Active\nMinutes",
                value: "\(activeMinutes)",
                unit: "min"
            )
        }
    }

    private func statCard(icon: String, iconColor: Color, title: String, value: String, unit: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(iconColor)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(iconColor.opacity(0.12))
                )

            Text(title)
                .font(.custom("LexendDeca-Regular", size: 11))
                .foregroundColor(Color.StepTrackerSemantic.insightSubtitle)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 28)

            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.custom("PlusJakartaSans-Bold", size: 18))
                    .foregroundColor(Color.StepTrackerSemantic.chartTitle)
                Text(unit)
                    .font(.custom("LexendDeca-Regular", size: 11))
                    .foregroundColor(Color.StepTrackerSemantic.insightSubtitle)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.StepTrackerSemantic.chartCardBackground)
                .customLightShadow()
        )
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
