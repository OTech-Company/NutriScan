//
//  WorkoutActiveControlsView.swift
//  NutriScan
//

import SwiftUI

struct WorkoutActiveControlsView: View {
    var viewModel: ExerciseWorkoutPlayerViewModel
    var onCancelWorkout: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                // Restart Button
                Button {
                    viewModel.showRestartAlert = true
                } label: {
                    Text("Restart")
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

                // Pause Button
                Button {
                    viewModel.pauseTimer()
                } label: {
                    Text("Pause")
                        .font(Font.AppFont.subtitle2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.Teal.teal1000)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }

            // Cancel Workout Text Link
            Button {
                viewModel.showCancelAlert = true
            } label: {
                Text("Cancel workout")
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(Color.ExerciseSemantic.cancelWorkoutText)
            }
            .padding(.top, 4)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
    }
}
