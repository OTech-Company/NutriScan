//
//  WaterTrackingSection.swift
//  NutriScan
//
//  Created by albaraa alsayed on 24/07/2026.
//

import SwiftUI

struct WaterTrackingSection: View {
    let currentGlasses: Int
    let goalGlasses: Int
    var isUpdating: Bool = false
    var isLoading = false

    var onAddTargetCupTap: () -> Void = {}

    var onFillCup: (_ index: Int) -> Void = { _ in }

    var onUnfillCupRequest: (_ index: Int) -> Void = { _ in }

    var onDeleteTargetCupRequest: () -> Void = {}

    @State private var showCups = false
    @State private var fillingCupIndex: Int? = nil

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Water")
                    .font(Font.AppFont.subtitle1)
                    .foregroundStyle(Color.CaloriesSemantic.waterTitle)
                Spacer()
                if isLoading {
                    CaloriesTextShimmer(width: 38, height: 13, cornerRadius: 4)
                } else {
                    Text("\(currentGlasses)/\(goalGlasses)")
                        .font(Font.AppFont.textDefault)
                        .foregroundStyle(Color.CaloriesSemantic.waterCount)
                        .contentTransition(.numericText())
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentGlasses)
                }
            }

            HStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0..<goalGlasses, id: \.self) { index in
                            let isFilled = index < currentGlasses
                            CupView(
                                index: index,
                                isFilled: isFilled,
                                isAnimatingFill: fillingCupIndex == index,
                                showCups: showCups
                            )
                            .gesture(
                                LongPressGesture(minimumDuration: 0.6)
                                    .exclusively(before: TapGesture())
                                    .onEnded { result in
                                        switch result {
                                        case .first:
                                            if goalGlasses > 1 {
                                                onDeleteTargetCupRequest()
                                            }
                                        case .second:
                                            handleCupTap(index: index, isFilled: isFilled)
                                        }
                                    }
                            )
                            .allowsHitTesting(!isUpdating && !isLoading)
                            .accessibilityLabel("Water cup \(index + 1) of \(goalGlasses)")
                            .accessibilityValue(isFilled ? "Drunk" : "Not drunk")
                            .accessibilityHint("Tap to change consumed water. Long press to reduce the target.")
                            .accessibilityAddTraits(.isButton)
                            .accessibilityAction {
                                handleCupTap(index: index, isFilled: isFilled)
                            }
                            .accessibilityAction(named: "Decrease water target") {
                                if goalGlasses > 1 { onDeleteTargetCupRequest() }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }

                Spacer()

                AddCircleButton(
                    accessibilityLabel: "Increase water target",
                    accessibilityHint: "Adds one cup to today's water goal",
                    action: onAddTargetCupTap
                )
                .allowsHitTesting(!isUpdating && !isLoading)
                .opacity(isUpdating || isLoading ? 0.5 : 1)
            }
            .padding(16)
            .frame(height: 74)
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(Color.CaloriesSemantic.cardBackground)
            }
            .customLightShadow()
        }
        .onAppear {
            withAnimation {
                showCups = true
            }
        }
    }

    private func handleCupTap(index: Int, isFilled: Bool) {
        if isFilled {
            onUnfillCupRequest(index)
        } else {
            fillingCupIndex = index
            onFillCup(index)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                fillingCupIndex = nil
            }
        }
    }

}

private struct CupView: View {
    let index: Int
    let isFilled: Bool
    let isAnimatingFill: Bool
    let showCups: Bool

    @State private var fillProgress: CGFloat = 0

    var body: some View {
        ZStack {
            Image(.strokeCup)
                .foregroundStyle(Color.CaloriesSemantic.waterEmptyCup)

            if isFilled || isAnimatingFill {
                Image(.filledCup)
                    .foregroundStyle(Color.CaloriesSemantic.waterFilledCup)
                    .clipShape(
                        BottomToTopClipShape(progress: isFilled && !isAnimatingFill ? 1.0 : fillProgress)
                    )
            }
        }
        .scaleEffect(showCups ? 1 : 0)
        .opacity(showCups ? 1 : 0)
        .animation(
            .spring(response: 0.4, dampingFraction: 0.6)
                .delay(Double(index) * 0.06),
            value: showCups
        )
        .onChange(of: isAnimatingFill) { _, newValue in
            if newValue {
                fillProgress = 0
                withAnimation(.easeInOut(duration: 0.4)) {
                    fillProgress = 1.0
                }
            } else {
                fillProgress = 0
            }
        }
        .onChange(of: isFilled) { _, newFilled in
            if !newFilled {
                withAnimation(.easeOut(duration: 0.3)) {
                    fillProgress = 0
                }
            }
        }
    }
}

private struct BottomToTopClipShape: Shape {
    var progress: CGFloat

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let revealHeight = rect.height * progress
        let startY = rect.maxY - revealHeight
        return Path(CGRect(x: rect.minX, y: startY, width: rect.width, height: revealHeight))
    }
}

#Preview("Light - 4/8") {
    WaterTrackingSection(
        currentGlasses: 4, goalGlasses: 8,
        onFillCup: { _ in },
        onUnfillCupRequest: { _ in }
    )
    .padding()
    .background(Color.CaloriesSemantic.background)
    .preferredColorScheme(.light)
}

#Preview("Dark - 6/8") {
    WaterTrackingSection(
        currentGlasses: 6, goalGlasses: 8,
        onFillCup: { _ in },
        onUnfillCupRequest: { _ in }
    )
    .padding()
    .background(Color.Teal.teal1600)
    .preferredColorScheme(.dark)
}
