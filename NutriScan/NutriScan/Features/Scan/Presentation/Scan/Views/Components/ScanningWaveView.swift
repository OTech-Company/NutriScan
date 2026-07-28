import SwiftUI

/// Animated scanning line that moves vertically through the viewfinder.
struct ScanningWaveView: View {
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            let cycle = time.remainder(dividingBy: 2.5)
            let progress = cycle / 2.5

            GeometryReader { geo in
                let yOffset = (progress - 0.5) * geo.size.height

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
        }
    }
}
