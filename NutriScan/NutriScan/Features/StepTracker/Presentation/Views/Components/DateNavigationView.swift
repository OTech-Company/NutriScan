import SwiftUI

struct DateNavigationView: View {
    let displayedDate: String
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

            Text(displayedDate)
                .font(.custom("PlusJakartaSans-SemiBold", size: 17))
                .foregroundColor(Color.StepTrackerSemantic.chartTitle)

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
        displayedDate: "Today, Oct 26",
        canGoForward: true,
        canGoBack: false,
        onPrevious: {},
        onNext: {}
    )
    .padding()
}
