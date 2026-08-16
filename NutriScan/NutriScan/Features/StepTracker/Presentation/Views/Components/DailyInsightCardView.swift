import SwiftUI

struct DailyInsightCardView: View {
    let steps: Int
    let goalSteps: Int
    let weeklyAverage: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(LocalizationKeys.StepTracker.dailyInsight.localized)
                .font(.custom("PlusJakartaSans-SemiBold", size: 18))
                .foregroundColor(Color.StepTrackerSemantic.chartTitle)

            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(Color.Teal.teal200, lineWidth: 5)
                        .frame(width: 56, height: 56)

                    Circle()
                        .trim(from: 0, to: min(Double(steps) / Double(goalSteps), 1.0))
                        .stroke(Color.Teal.teal1000, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                        .frame(width: 56, height: 56)
                        .rotationEffect(.degrees(-90))

                    Image(systemName: "figure.walk")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color.Teal.teal1000)
                }
                .environment(\.layoutDirection, .leftToRight)

                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(steps.formatted())")
                            .font(.custom("PlusJakartaSans-Bold", size: 24))
                            .foregroundColor(Color.Teal.teal1000)
                        Text(LocalizationKeys.StepTracker.steps.localized)
                            .font(.custom("LexendDeca-Regular", size: 14))
                            .foregroundColor(Color.StepTrackerSemantic.insightSubtitle)
                    }
                    Text("\(LocalizationKeys.StepTracker.ofGoal.localized) \(goalSteps.formatted())")
                        .font(.custom("LexendDeca-Regular", size: 13))
                        .foregroundColor(Color.StepTrackerSemantic.insightSubtitle)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(LocalizationKeys.StepTracker.periodAverage.localized)
                        .font(.custom("LexendDeca-Regular", size: 12))
                        .foregroundColor(Color.StepTrackerSemantic.insightSubtitle)
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(weeklyAverage.formatted())")
                            .font(.custom("PlusJakartaSans-Bold", size: 20))
                            .foregroundColor(Color.StepTrackerSemantic.chartTitle)
                        Text(LocalizationKeys.StepTracker.steps.localized)
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
}

#Preview {
    DailyInsightCardView(steps: 8_432, goalSteps: 10_000, weeklyAverage: 7_200)
        .padding()
}
