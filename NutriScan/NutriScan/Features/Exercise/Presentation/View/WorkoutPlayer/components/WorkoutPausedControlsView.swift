//
//  WorkoutPausedControlsView.swift
//  NutriScan
//

import SwiftUI

struct WorkoutPausedControlsView: View {
    var viewModel: ExerciseWorkoutPlayerViewModel

    var body: some View {
        VStack(spacing: 16) {
            // Stepper Chips (Sets & Reps)
            HStack(spacing: 12) {
                WorkoutStepperChip(
                    title: "Sets",
                    value: viewModel.setsCount,
                    onIncrement: { viewModel.incrementSets() },
                    onDecrement: { viewModel.decrementSets() }
                )

                WorkoutStepperChip(
                    title: "Reps",
                    value: viewModel.repsCount,
                    onIncrement: { viewModel.incrementReps() },
                    onDecrement: { viewModel.decrementReps() }
                )
            }

            HStack(spacing: 16) {
                // Resume Button
                Button {
                    viewModel.resumeTimer()
                } label: {
                    Text("Resume")
                        .font(Font.AppFont.subtitle2)
                        .foregroundColor(Color.ExerciseSemantic.outlineButtonText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.ExerciseSemantic.screenBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .strokeBorder(Color.ExerciseSemantic.outlineButtonBorder, lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                // Finish Button
                Button {
                    viewModel.showSuccessDialog = true
                } label: {
                    Text("Finish")
                        .font(Font.AppFont.subtitle2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.Teal.teal1000)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
    }
}
