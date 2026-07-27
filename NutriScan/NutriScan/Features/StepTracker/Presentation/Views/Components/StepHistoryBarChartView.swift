//
//  StepHistoryBarChartView 2.swift
//  NutriScan
//
//  Created by Osama Hosam on 22/07/2026.
//

import SwiftUI
import Charts

struct StepHistoryBarChartView: View {
    let history: [DailySteps]
    let goalSteps: Int
    let range: StepHistoryRange



    /// How many days between two consecutive x-axis labels, chosen so
    /// labels never overlap regardless of how wide the date range is.
    private var axisStrideDays: Int {
        switch range {
        case .sinceYesterday: return 1
        case .lastWeek: return 1
        case .lastMonth: return 5
        case .last3Months: return 14
        case .last6Months: return 30
        }
    }

    /// Longer ranges show only month (or month+day) to keep labels short.
    private var axisDateFormat: Date.FormatStyle {
        switch range {
        case .sinceYesterday, .lastWeek, .lastMonth:
            return .dateTime.day().month(.abbreviated)
        case .last3Months, .last6Months:
            return .dateTime.month(.abbreviated)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Step History")
                .font(.custom("PlusJakartaSans-SemiBold", size: 18))
                .foregroundColor(Color.CaloriesSemantic.chartTitle)

            if history.isEmpty {
                emptyState
            } else {
                chart
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.CaloriesSemantic.chartCardBackground)
                .customTealShadow()
        )
    }

    private var chart: some View {
        Chart(history, id: \.date) { day in
            BarMark(
                x: .value("Day", day.date, unit: .day),
                y: .value("Steps", day.stepCount)
            )
            .foregroundStyle(barColor(for: day.stepCount))
            .cornerRadius(4)

            RuleMark(y: .value("Goal", goalSteps))
                .foregroundStyle(Color.Teal.teal500)
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))
        }
        .chartYAxis {
            AxisMarks(position: .leading) { _ in
                AxisGridLine()
                    .foregroundStyle(Color.Gray.gray300.opacity(0.5))
                AxisValueLabel()
                    .font(.custom("LexendDeca-Regular", size: 11))
                    .foregroundStyle(Color.CaloriesSemantic.axisText)
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: axisStrideDays)) { _ in
                AxisGridLine()
                    .foregroundStyle(Color.Gray.gray300.opacity(0.3))
                AxisValueLabel(format: axisDateFormat)
                    .font(.custom("LexendDeca-Regular", size: 10))
                    .foregroundStyle(Color.CaloriesSemantic.axisText)
            }
        }
        .frame(height: 220)
    }

    /// Bars that reached the goal render in the deeper teal;
    /// bars below goal render in the lighter, "uncompleted" teal.
    private func barColor(for steps: Int) -> Color {
        steps >= goalSteps ? Color.Teal.teal700 : Color.Teal.teal400
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "chart.bar")
                .font(.system(size: 28))
                .foregroundColor(Color.Teal.teal400)
            Text("No step history yet")
                .font(.custom("LexendDeca-Regular", size: 14))
                .foregroundColor(Color.CaloriesSemantic.axisText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

#Preview {
    ZStack {
        Color.Gray.gray100.ignoresSafeArea()
        StepHistoryBarChartView(
            history: (0..<7).map { offset in
                DailySteps(
                    date: Calendar.current.date(byAdding: .day, value: -offset, to: Date())!,
                    stepCount: Int.random(in: 3000...12000)
                )
            }.reversed(),
            goalSteps: 10_000,
            range: .lastWeek
        )
        .padding()
    }
}
