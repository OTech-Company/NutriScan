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
            if !viewModel.hasStarted {
                // Start Button
                CustomPuffedButton(title: LocalizationKeys.Common.start.localized, action: {
                    viewModel.startWorkout()
                })
            } else {
                HStack(spacing: 16) {
                    // Restart Button
                    Button {
                        viewModel.alert = .restart
                    } label: {
                        Text(LocalizationKeys.Exercise.restart.localized)
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
                        Text(LocalizationKeys.Exercise.pause.localized)
                            .font(Font.AppFont.subtitle2)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.Teal.teal1000)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
            }

            // Cancel Workout Text Link
            Button {
                onCancelWorkout()
            } label: {
                Text(LocalizationKeys.Exercise.cancel.localized)
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(Color.ExerciseSemantic.cancelWorkoutText)
            }
            .padding(.top, 4)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
    }
}
