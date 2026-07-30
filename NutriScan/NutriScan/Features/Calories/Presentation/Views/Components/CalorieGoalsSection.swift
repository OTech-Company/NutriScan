//
//  CalorieGoalsSection.swift
//  NutriScan
//
//  Created by albaraa alsayed on 22/07/2026.
//

import SwiftUI

struct CalorieGoalsSection: View {
    let mealCalories: Int
    let targetCalories: Double?
    let caloriesBurned: Int
    var onCompleteProfileTap: () -> Void = {}

    @State private var animatedProgress: CGFloat = 0
    @State private var isTapped = false

    private var rawNetCalories: Int { mealCalories - caloriesBurned }
    private var netCalories: Int { max(rawNetCalories, 0) }

    private var targetProgress: CGFloat {
        guard let targetCalories, targetCalories > 0 else { return 0 }
        return min(max(CGFloat(Double(netCalories) / targetCalories), 0), 1.0)
    }

    private var isOverTDEE: Bool {
        guard let targetCalories else { return false }
        return Double(rawNetCalories) > targetCalories
    }

    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 4) {
                            Image("calories-fill")
                            Text("Calorie Goals")
                                .font(Font.AppFont.subtitle1)
                                .foregroundStyle(Color.CaloriesSemantic.goalsTitle)
                        }

                        VStack(spacing: 8) {
                            if let targetCalories {
                                calorieRow(title: "Your TDEE", calories: Int(targetCalories.rounded()))
                            } else {
                                Button(action: onCompleteProfileTap) {
                                    HStack(spacing: 4) {
                                        Text("Complete Personal Information")
                                        Image(systemName: "chevron.right")
                                    }
                                    .font(Font.AppFont.textCaption)
                                    .foregroundStyle(Color.CaloriesSemantic.goalsValueText)
                                }
                                .accessibilityHint("Opens Personal Information to set your calorie goal")
                            }
                            calorieRow(title: "Calories Gained", calories: mealCalories)
                            calorieRow(title: "Calories Burned", calories: caloriesBurned)
                        }
                    }
                    Spacer(minLength: 16)

                    Group {
                        if isOverTDEE {
                            Image(.angryFace)
                        } else {
                            Image(.normalFace)
                        }
                    }
                    .transition(
                        .asymmetric(
                            insertion: .scale(scale: 0.6).combined(with: .opacity),
                            removal: .scale(scale: 0.6).combined(with: .opacity)
                        )
                    )
                    .scaleEffect(isTapped ? 1.3 : 1.0)
                    .rotationEffect(.degrees(isOverTDEE && isTapped ? -15 : 0))
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isOverTDEE)
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
        .frame(height: 185)
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
    }

    private func calorieRow(title: String, calories: Int) -> some View {
        HStack {
            Text(title)
                .font(Font.AppFont.textSecondary)
                .foregroundStyle(Color.CaloriesSemantic.goalsLabelText)
            Spacer()
            Text("\(calories) Kcal")
                .font(Font.AppFont.textSecondary)
                .foregroundStyle(Color.CaloriesSemantic.goalsValueText)
                .contentTransition(.numericText())
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: calories)
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
