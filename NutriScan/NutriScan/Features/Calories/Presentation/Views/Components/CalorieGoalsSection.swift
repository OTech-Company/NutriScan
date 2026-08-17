//
//  CalorieGoalsSection.swift
//  NutriScan
//
//  Created by albaraa alsayed on 22/07/2026.
//

import SwiftUI

private enum CalorieGoalMood: Hashable {
    case sad
    case normal
    case happy
    case angry

    var imageResource: ImageResource {
        switch self {
        case .sad: .sadFace
        case .normal: .normalFace
        case .happy: .happyFace
        case .angry: .angryFace
        }
    }
}

struct CalorieGoalsSection: View {
    let mealCalories: Int
    let targetCalories: Double?
    let caloriesBurned: Double
    var isLoading = false
    var onCompleteProfileTap: () -> Void = {}

    @State private var animatedProgress: CGFloat = 0
    @State private var isTapped = false

    private var rawNetCalories: Double { Double(mealCalories) - caloriesBurned }
    private var netCalories: Double { max(rawNetCalories, 0) }

    private var targetProgress: CGFloat {
        guard let targetCalories, targetCalories > 0 else { return 0 }
        return min(max(CGFloat(netCalories / targetCalories), 0), 1.0)
    }

    private var isOverTDEE: Bool {
        mood == .angry
    }

    private var mood: CalorieGoalMood {
        guard let targetCalories, targetCalories > 0 else { return .normal }
        let progress = netCalories / targetCalories
        switch progress {
        case ..<0.5: return .sad
        case ..<0.8: return .normal
        case ...1.0: return .happy
        default: return .angry
        }
    }

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 4) {
                            Image("calories-fill")
                            Text(LocalizationKeys.Calories.calorieGoals.localized)
                                .font(Font.AppFont.subtitle1)
                                .foregroundStyle(Color.CaloriesSemantic.goalsTitle)
                        }

                        VStack(spacing: 8) {
                            if isLoading {
                                calorieRow(title: LocalizationKeys.Calories.yourTDEE.localized, calories: nil)
                            } else if let targetCalories {
                                calorieRow(title: LocalizationKeys.Calories.yourTDEE.localized, calories: Int(targetCalories.rounded()))
                            } else {
                                Button(action: onCompleteProfileTap) {
                                    HStack(spacing: 4) {
                                        Text(LocalizationKeys.Calories.completePersonalInfo.localized)
                                        Image(systemName: "chevron.right")
                                            .flipsForRightToLeftLayoutDirection(true)
                                    }
                                    .font(Font.AppFont.textCaption)
                                    .foregroundStyle(Color.CaloriesSemantic.goalsValueText)
                                }
                                .accessibilityHint(LocalizationKeys.Accessibility.opensPersonalInfo.localized)
                            }
                            calorieRow(
                                title: LocalizationKeys.Calories.caloriesGained.localized,
                                calories: isLoading ? nil : mealCalories
                            )
                            calorieRow(
                                title: LocalizationKeys.Calories.caloriesBurned.localized,
                                calories: isLoading ? nil : Int(caloriesBurned.rounded())
                            )
                        }
                    }
                    Spacer(minLength: 16)

                    Image(mood.imageResource)
                    .id(mood)
                    .transition(
                        .asymmetric(
                            insertion: .scale(scale: 0.6).combined(with: .opacity),
                            removal: .scale(scale: 0.6).combined(with: .opacity)
                        )
                    )
                    .scaleEffect(isTapped ? 1.3 : 1.0)
                    .rotationEffect(.degrees(mood == .angry && isTapped ? -15 : 0))
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: mood)
                }

                Spacer()

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.CaloriesSemantic.goalsProgressTrack)

                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                isOverTDEE
                                    ? Color.red.opacity(0.75)
                                    : Color.CaloriesSemantic.goalsProgressFill
                            )
                            .frame(width: geometry.size.width * animatedProgress)
                            .animation(.easeOut(duration: 0.5), value: isOverTDEE)
                    }
                }
                .frame(height: 5)
            }
        }
        .padding(16)
        .frame(height: 175)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.CaloriesSemantic.goalsBackground)
        )
        .scaleEffect(isTapped ? 0.97 : 1.0)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                isTapped = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    isTapped = false
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                animatedProgress = targetProgress
            }
        }
        .onChange(of: mealCalories) { _, _ in
            withAnimation(.easeOut(duration: 0.5)) {
                animatedProgress = targetProgress
            }
        }
        .onChange(of: caloriesBurned) { _, _ in
            withAnimation(.easeOut(duration: 0.5)) {
                animatedProgress = targetProgress
            }
        }
        .onChange(of: targetCalories) { _, _ in
            withAnimation(.easeOut(duration: 0.5)) {
                animatedProgress = targetProgress
            }
        }
    }

    private func calorieRow(title: String, calories: Int?) -> some View {
        HStack {
            Text(title)
                .font(Font.AppFont.textSecondary)
                .foregroundStyle(Color.CaloriesSemantic.goalsLabelText)
            Spacer()
            Group {
                if let calories {
                    Text("\(calories) Kcal")
                        .font(Font.AppFont.textSecondary)
                        .foregroundStyle(Color.CaloriesSemantic.goalsValueText)
                        .contentTransition(.numericText())
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: calories)
                } else {
                    CaloriesTextShimmer(
                        width: 52,
                        height: 9,
                        cornerRadius: 4,
                        color: Color.CaloriesSemantic.goalsValueText.opacity(0.5)
                    )
                    .padding(.vertical, 3)
                }
            }
            .padding(.horizontal, 4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color.CaloriesSemantic.goalsValueBackground)
            )
        }
    }
}

#Preview("Light — Under TDEE") {
    CalorieGoalsSection(mealCalories: 1200, targetCalories: 2350, caloriesBurned: 100)
        .padding()
        .background(Color.CaloriesSemantic.background)
        .preferredColorScheme(.light)
}

#Preview("Light — Over TDEE") {
    CalorieGoalsSection(mealCalories: 2500, targetCalories: 2350, caloriesBurned: 0)
        .padding()
        .background(Color.CaloriesSemantic.background)
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    CalorieGoalsSection(mealCalories: 0, targetCalories: nil, caloriesBurned: 0)
        .padding()
        .background(Color.Teal.teal1600)
        .preferredColorScheme(.dark)
}
