//
//  ExerciseCardView.swift
//  NutriScan
//
//  Created by albaraa alsayed on 24/07/2026.
//

import SwiftUI

struct ExerciseCardView: View {
    let exerciseKcal: Int
    let exerciseMinutes: Int
    var onAddTap: () -> Void = {}
    
    @State private var isTapped = false
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(.exerciseIcon)
                        .padding(8)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(Color.CaloriesSemantic.exerciseIconBackground)
                        }
                        .scaleEffect(showContent ? 1 : 0)
                        .rotationEffect(.degrees(showContent ? 0 : -45))
                    Text("Your\nExercise")
                        .font(Font.AppFont.textCaption)
                        .foregroundStyle(Color.CaloriesSemantic.exerciseTitle)
                        .opacity(showContent ? 1 : 0)
                        .offset(x: showContent ? 0 : -10)
                    Spacer()
                    AddCircleButton(action: onAddTap)
                }
                Spacer()
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 4) {
                        Text("\(exerciseKcal)")
                            .font(Font.AppFont.numbers)
                            .foregroundStyle(Color.CaloriesSemantic.exerciseKcalValue)
                            .contentTransition(.numericText())
                        Text("Kcal")
                            .font(Font.AppFont.textSecondary)
                            .foregroundStyle(Color.CaloriesSemantic.exerciseSubtitle)
                    }
                    Text("\(exerciseMinutes) min today")
                        .font(Font.AppFont.textSecondary)
                        .foregroundStyle(Color.CaloriesSemantic.exerciseSubtitle)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 10)
            }
        }
        .padding(16)
        .frame(height: 126)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .foregroundStyle(Color.CaloriesSemantic.cardBackground)
        }
        .customLightShadow()
        .scaleEffect(isTapped ? 0.95 : 1.0)
        .onTapGesture {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                isTapped = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isTapped = false
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.2)) {
                showContent = true
            }
        }
    }
}

#Preview("Light") {
    ExerciseCardView(exerciseKcal: 250, exerciseMinutes: 45)
        .padding()
        .background(Color.CaloriesSemantic.background)
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    ExerciseCardView(exerciseKcal: 250, exerciseMinutes: 45)
        .padding()
        .background(Color.Teal.teal1600)
        .preferredColorScheme(.dark)
}
