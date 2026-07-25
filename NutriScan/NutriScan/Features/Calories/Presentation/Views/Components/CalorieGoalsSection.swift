//
//  CalorieGoalsSection.swift
//  NutriScan
//
//  Created by albaraa alsayed on 22/07/2026.
//

import SwiftUI

struct CalorieGoalsSection: View {
    let currentTdee: Float
    let maxTdee: Float
    
    @State private var animatedProgress: CGFloat = 0
    @State private var isTapped = false
    
    private var targetProgress: CGFloat {
        guard maxTdee > 0 else { return 0 }
        return min(CGFloat(currentTdee / maxTdee), 1.0)
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
                            tdeeRow(title: "Your TDEE", calories: maxTdee)
                            tdeeRow(title: "Current", calories: currentTdee)
                        }
                    }
                    Spacer(minLength: 16)
                    Image(.angryFace)
                        .scaleEffect(isTapped ? 1.3 : 1.0)
                        .rotationEffect(.degrees(isTapped ? -15 : 0))
                }
                Spacer()
                // Progress bar — animates from 0 on appear
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.CaloriesSemantic.goalsProgressTrack)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.CaloriesSemantic.goalsProgressFill)
                            .frame(width: geometry.size.width * animatedProgress)
                    }
                }
                .frame(height: 5)
            }
        }
        .padding(16)
        .frame(height: 160)
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
        .onChange(of: currentTdee) { _, _ in
            withAnimation(.easeOut(duration: 0.5)) {
                animatedProgress = targetProgress
            }
        }
    }
    
    private func tdeeRow(title: String, calories: Float) -> some View {
        HStack {
            Text(title)
                .font(Font.AppFont.textSecondary)
                .foregroundStyle(Color.CaloriesSemantic.goalsLabelText)
            Spacer()
            Text("\(Int(calories)) Kcal")
                .font(Font.AppFont.textSecondary)
                .foregroundStyle(Color.CaloriesSemantic.goalsValueText)
                .padding(.horizontal, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color.CaloriesSemantic.goalsValueBackground)
                )
        }
    }
}

#Preview("Light") {
    CalorieGoalsSection(currentTdee: 1200, maxTdee: 2350)
        .padding()
        .background(Color.CaloriesSemantic.background)
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    CalorieGoalsSection(currentTdee: 1200, maxTdee: 2350)
        .padding()
        .background(Color.Teal.teal1600)
        .preferredColorScheme(.dark)
}
