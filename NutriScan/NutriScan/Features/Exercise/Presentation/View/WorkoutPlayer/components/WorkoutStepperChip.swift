//
//  WorkoutStepperChip.swift
//  NutriScan
//

import SwiftUI

struct WorkoutStepperChip: View {
    let title: String
    let value: Int
    let onIncrement: () -> Void
    let onDecrement: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(Font.AppFont.textSecondary)
                .foregroundColor(Color.ExerciseSemantic.stepperText)

            HStack(spacing: 6) {
                Button(action: onDecrement) {
                    Image(systemName: "minus")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color.ExerciseSemantic.stepperButton)
                }

                Text("\(value)")
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(Color.ExerciseSemantic.stepperText)
                    .frame(minWidth: 14)

                Button(action: onIncrement) {
                    Image(systemName: "plus")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color.ExerciseSemantic.stepperButton)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.Teal.teal400.opacity(0.4))
            .clipShape(Capsule())
        }
        .padding(.horizontal, 14)
        .frame(height: 36)
        .background(Color.ExerciseSemantic.stepperBg)
        .clipShape(Capsule())
    }
}

#Preview {
    HStack {
        WorkoutStepperChip(title: "Sets", value: 1, onIncrement: {}, onDecrement: {})
        WorkoutStepperChip(title: "Reps", value: 1, onIncrement: {}, onDecrement: {})
    }
    .padding()
}
