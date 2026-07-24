//  StepGaugeCardView.swift
//  StepTracker - Presentation / Views / Components

import SwiftUI

struct StepGaugeCardView: View {
    let currentSteps: Int
    let goalSteps: Int

    @State private var animatedProgress: Double = 0
    @State private var isTapped = false
    @State private var showContent = false

    private var targetProgress: Double {
        guard goalSteps > 0 else { return 0 }
        return min(Double(currentSteps) / Double(goalSteps), 1.0)
    }

    private let trackStart: Double = 0.1
    private let trackEnd: Double = 0.9
    private let gaugeRotation: Double = 90

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.CaloriesSemantic.cardBackground)
                .customLightShadow()

            ZStack {
                // Track
                Circle()
                    .trim(from: trackStart, to: trackEnd)
                    .stroke(
                        Color.Teal.teal200,
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .rotationEffect(.degrees(gaugeRotation))

                // Animated progress arc
                Circle()
                    .trim(from: trackStart, to: trackStart + (trackEnd - trackStart) * animatedProgress)
                    .stroke(
                        Color.Teal.teal700,
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(gaugeRotation))

                // Center text
                VStack(spacing: 2) {
                    Text("Steps")
                        .font(Font.AppFont.textCaption)
                        .foregroundColor(Color.CaloriesSemantic.stepsLabel)
                        .frame(width: 32, height: 15)

                    Text("\(currentSteps.formatted())")
                        .font(Font.AppFont.numbers)
                        .foregroundColor(Color.CaloriesSemantic.stepsNumber)
                        .contentTransition(.numericText())
                }
                .offset(y: -6)
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.5)
                
                // Bottom icon
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
            .padding(16)
        }
        .frame(width: 126, height: 126)
        .scaleEffect(isTapped ? 0.9 : 1.0)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                        isTapped = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        isTapped = false
                    }
                }
        )
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1)) {
                showContent = true
            }
            withAnimation(.easeOut(duration: 1.0).delay(0.3)) {
                animatedProgress = targetProgress
            }
        }
        .onChange(of: currentSteps) { _, _ in
            withAnimation(.easeInOut(duration: 0.6)) {
                animatedProgress = targetProgress
            }
        }
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
}
