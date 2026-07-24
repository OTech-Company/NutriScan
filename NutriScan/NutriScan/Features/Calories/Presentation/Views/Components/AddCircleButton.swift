//
//  AddCircleButton.swift
//  NutriScan
//
//  Created by albaraa alsayed on 24/07/2026.
//

import SwiftUI

/// Reusable circular "+" button used across the Calories feature.
/// - DailyProductsSection uses `size: 60`
/// - ExerciseCardView and WaterTrackingSection use the default `size: 36`
struct AddCircleButton: View {
    var size: CGFloat = 36
    var action: () -> Void = {}
    
    @State private var isTapped = false
    
    var body: some View {
        Button {
            // Bounce animation on tap
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                isTapped = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isTapped = false
                }
            }
            action()
        } label: {
            Image(.plus)
                .resizable()
                .scaledToFit()
                .frame(width: size * 0.4, height: size * 0.4)
                .foregroundColor(Color.CaloriesSemantic.addButtonIcon)
                .rotationEffect(.degrees(isTapped ? 90 : 0))
                .frame(width: size, height: size)
                .background(
                    Circle()
                        .foregroundStyle(
                            size > 50
                                ? Color.CaloriesSemantic.addButtonLargeBackground
                                : Color.CaloriesSemantic.addButtonBackground
                        )
                )
                .scaleEffect(isTapped ? 1.2 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

#Preview("Small") {
    AddCircleButton(size: 36) {}
        .padding()
        .background(Color.CaloriesSemantic.background)
}

#Preview("Large") {
    AddCircleButton(size: 60) {}
        .padding()
        .background(Color.CaloriesSemantic.background)
}
