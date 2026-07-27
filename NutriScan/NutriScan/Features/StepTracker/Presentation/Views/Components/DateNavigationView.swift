import SwiftUI

struct DateNavigationView: View {
    let startDate: String
    let endDate: String
    let canGoForward: Bool
    let canGoBack: Bool
    var onPrevious: () -> Void
    var onNext: () -> Void

    var body: some View {
        HStack {
            Button {
                onPrevious()
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
            .disabled(!canGoForward)
            .opacity(canGoForward ? 1 : 0.4)

            Spacer()

            HStack(spacing: 6) {
                Text(startDate)
                    .font(.custom("PlusJakartaSans-SemiBold", size: 14))
                    .foregroundColor(Color.StepTrackerSemantic.chartTitle)

                Text("—")
                    .font(.custom("PlusJakartaSans-SemiBold", size: 14))
                    .foregroundColor(Color.StepTrackerSemantic.insightSubtitle)

                Text(endDate)
                    .font(.custom("PlusJakartaSans-SemiBold", size: 14))
                    .foregroundColor(Color.StepTrackerSemantic.chartTitle)
            }

            Spacer()

            Button {
                onNext()
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
            .disabled(!canGoBack)
            .opacity(canGoBack ? 1 : 0.4)
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    DateNavigationView(
        startDate: "Jul 21",
        endDate: "Jul 27",
        canGoForward: true,
        canGoBack: false,
        onPrevious: {},
        onNext: {}
    )
    .padding()
}