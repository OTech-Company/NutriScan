import SwiftUI

struct RangePickerView: View {
    @Binding var selectedRange: StepHistoryRange

    var body: some View {
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
            }
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
}

#Preview {
    @Previewable @State var range: StepHistoryRange = .lastWeek
    RangePickerView(selectedRange: $range)
        .padding()
}
