//  StepGaugeCardView.swift
//  StepTracker - Presentation / Views / Components

import SwiftUI

struct StepGaugeCardView: View {
    let currentSteps: Int
    let goalSteps: Int

    @Environment(\.colorScheme) private var colorScheme

    private var progress: Double {
        guard goalSteps > 0 else { return 0 }
        return min(Double(currentSteps) / Double(goalSteps), 1.0)
    }

    /// Arc opens 90° at bottom (from 135° clockwise to 45°)
    private let trackStart: Double = 0.125
    private let trackEnd: Double = 0.875
    private let gaugeRotation: Double = 90

    private var cardBackground: Color {
        Color(light: .white, dark: Color.Gray.gray1600)
    }

    private var stepsNumberColor: Color {
        Color(light: Color.Gray.gray1600, dark: .white)
    }

    private var stepsLabelColor: Color {
        Color(light: Color.Gray.gray700, dark: Color.Gray.gray500)
    }

    var body: some View {
        ZStack {
            // Card Background
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(cardBackground)
                .customTealShadow()

            // Gauge & Content Layer
            ZStack {
                // 1. Unfilled Background Track
                Circle()
                    .trim(from: trackStart, to: trackEnd)
                    .stroke(
                        Color.Teal.teal200.opacity(0.6),
                        style: StrokeStyle(lineWidth: 13, lineCap: .round)
                    )
                    .rotationEffect(.degrees(gaugeRotation))

                // 2. Active Progress Arc
                Circle()
                    .trim(from: trackStart, to: trackStart + (trackEnd - trackStart) * progress)
                    .stroke(
                        Color.Teal.teal700,
                        style: StrokeStyle(lineWidth: 13, lineCap: .round)
                    )
                    .rotationEffect(.degrees(gaugeRotation))
                    .animation(.easeInOut(duration: 0.6), value: progress)

                // 3. Center Text (Steps & Number)
                VStack(spacing: 2) {
                    Text("Steps")
                        .font(Font.AppFont.textCaption)
                        .foregroundColor(stepsLabelColor)
                        .frame(width: 32, height: 15)

                    Text("\(currentSteps.formatted())")
                        .font(.custom("Manrope-Bold", size: 19))
                        .foregroundColor(stepsNumberColor)
                }
                .offset(y: -6) // Pushes text upward into the true visual center of the arc

                // 4. Footprint Icon (Placed right at the bottom gap)
                VStack {
                    Spacer()
                    Image("steps_icon")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 18, height: 20)
                        .foregroundColor(Color.Teal.teal400)
                }
                .padding(.bottom, 2)
            }
            .padding(16) // Padding inside the card boundary
        }
        .frame(width: 156, height: 165)
    }
}

#Preview {
    ZStack {
        Color.Gray.gray100.ignoresSafeArea()
        StepGaugeCardView(currentSteps: 3_500, goalSteps: 10_000)
    }
}

#Preview("Dark") {
    ZStack {
        Color.Gray.gray1600.ignoresSafeArea()
        StepGaugeCardView(currentSteps: 3_500, goalSteps: 10_000)
    }
    .preferredColorScheme(.dark)
}
