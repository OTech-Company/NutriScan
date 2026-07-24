import SwiftUI

struct ScanningIndicator: View {
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color.ScanSemantic.scanningPulse.opacity(0.3), lineWidth: 4)
                    .frame(width: 80, height: 80)

                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        Color.ScanSemantic.scanningPulse,
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(
                        .linear(duration: 1.2).repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            }

            Text("Analyzing your food...")
                .font(Font.AppFont.textPrimary)
                .foregroundColor(Color.ScanSemantic.scanningText)
        }
        .onAppear {
            isAnimating = true
        }
    }
}
