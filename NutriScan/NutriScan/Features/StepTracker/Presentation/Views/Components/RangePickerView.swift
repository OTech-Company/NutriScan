import SwiftUI

struct RangePickerView: View {
    @Binding var selectedRange: StepHistoryRange

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                chipButton(title: "Week", range: .lastWeek)
                chipButton(title: "Month", range: .lastMonth)
                chipButton(title: "3 Months", range: .last3Months)
                chipButton(title: "6 Months", range: .last6Months)
            }
            .padding(.horizontal, 20)
        }
    }

    private func chipButton(title: String, range: StepHistoryRange) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedRange = range
            }
        } label: {
            Text(title)
                .font(.custom("LexendDeca-Regular", size: 13))
                .foregroundColor(
                    selectedRange == range
                        ? Color(light: Color.Teal.teal1000, dark: Color.Teal.teal1000)
                        : Color(light: Color.Gray.gray700, dark: Color.Teal.teal1400)
                )
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .frame(height: 34)
                .background(
                    Color(light: .white, dark: Color.Teal.teal1600)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .strokeBorder(
                            selectedRange == range
                                ? Color(light: Color.Teal.teal1000, dark: Color.Teal.teal1000)
                                : Color(light: Color.Gray.gray400, dark: Color.Teal.teal1400),
                            lineWidth: 1
                        )
                )
                .clipShape(RoundedRectangle(cornerRadius: 32))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var range: StepHistoryRange = .lastWeek
    RangePickerView(selectedRange: $range)
        .padding()
}
