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
                // Start / Restart Button
                Button {
                    if viewModel.hasStarted {
                        viewModel.showRestartAlert = true
                    } else {
                        viewModel.startWorkout()
                    }
                } label: {
                    Text(viewModel.hasStarted ? "Restart" : "Start")
                        .font(Font.AppFont.subtitle2)
                        .foregroundColor(viewModel.hasStarted ? Color.ExerciseSemantic.outlineButtonText : .white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(viewModel.hasStarted ? Color.ExerciseSemantic.screenBackground : Color.Teal.teal1000)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .strokeBorder(viewModel.hasStarted ? Color.ExerciseSemantic.outlineButtonBorder : Color.clear, lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                // Pause Button (visible once started)
                if viewModel.hasStarted {
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
            }

            // Cancel Workout Text Link
            Button {
                onCancelWorkout()
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
