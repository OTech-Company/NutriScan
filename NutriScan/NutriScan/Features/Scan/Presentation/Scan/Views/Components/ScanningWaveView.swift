import SwiftUI

/// Animated scanning line that moves vertically through the viewfinder.
struct ScanningWaveView: View {
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { timeline in
            let period: Double = 2.5
            let time = timeline.date.timeIntervalSinceReferenceDate
            // NOTE: `time` is always positive (dates post-2001), so
            // `truncatingRemainder` is safe here and guarantees a result in
            // [0, period) — unlike `.remainder(dividingBy:)` (IEEE remainder),
            // which can return a *negative* value even for positive input.
            // That was the bug: progress would go negative for roughly half
            // of every cycle, pushing the line's offset a full container-
            // height above the clipped viewfinder, so it rendered invisible
            // for most of the animation.
            let progress = time.truncatingRemainder(dividingBy: period) / period // always in [0, 1)

            GeometryReader { geo in
                let yOffset = progress * geo.size.height

                ZStack(alignment: .top) {
                    // Main bright line
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.Teal.teal1000.opacity(0),
                                    Color.Teal.teal1000.opacity(0.6),
                                    Color.Teal.teal1000,
                                    Color.Teal.teal1000.opacity(0.6),
                                    Color.Teal.teal1000.opacity(0)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 2)
                        .offset(y: yOffset)

                    // Glow above the line
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.Teal.teal1000.opacity(0),
                                    Color.Teal.teal1000.opacity(0.12)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 60)
                        .offset(y: yOffset - 60)

                    // Glow below the line
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.Teal.teal1000.opacity(0.12),
                                    Color.Teal.teal1000.opacity(0)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 60)
                        .offset(y: yOffset + 2)
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                .clipped()
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ScanningWaveView()
            .frame(width: 240, height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
