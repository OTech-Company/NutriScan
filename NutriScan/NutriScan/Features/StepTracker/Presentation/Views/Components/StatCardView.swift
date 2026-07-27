import SwiftUI

struct StatCardView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    let unit: String

    var body: some View {
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
    HStack(spacing: 12) {
        StatCardView(icon: "flame.fill", iconColor: .orange, title: "Calories\nBurned", value: "420", unit: "kcal")
        StatCardView(icon: "mappin.circle.fill", iconColor: Color.Teal.teal1000, title: "Distance\nCovered", value: "5.2", unit: "km")
        StatCardView(icon: "stopwatch.fill", iconColor: Color.Teal.teal1000, title: "Active\nMinutes", value: "45", unit: "min")
    }
    .padding()
}
