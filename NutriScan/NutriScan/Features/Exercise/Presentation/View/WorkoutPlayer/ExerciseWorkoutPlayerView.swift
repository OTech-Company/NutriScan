//
//  ExerciseWorkoutPlayerView.swift
//  NutriScan
//

import SwiftUI

struct ExerciseWorkoutPlayerView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var viewModel: ExerciseWorkoutPlayerViewModel

    init(exercise: Exercise) {
        _viewModel = State(initialValue: ExerciseWorkoutPlayerViewModel(exercise: exercise))
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {

                // MARK: Top Navigation Bar
                HStack(spacing: 16) {
                    BackButton {
                        if viewModel.elapsedSeconds > 0 {
                            viewModel.showCancelAlert = true
                        } else {
                            router.pop()
                        }
                    }

                    Text("Exercise")
                        .font(Font.AppFont.subtitle1)
                        .foregroundColor(Color.ExerciseSemantic.rowTitle)

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)

                // MARK: Exercise Title
                Text(viewModel.exercise.name)
                    .font(Font.AppFont.title3)
                    .foregroundColor(Color.ExerciseSemantic.rowTitle)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                Spacer()

                // MARK: Illustration Circle
                ZStack {
                    Circle()
                        .fill(Color.ExerciseSemantic.playerCircleBg)
                        .frame(width: 260, height: 260)

                    Image(systemName: viewModel.exercise.imageName ?? "figure.cross.training")
                        .font(.system(size: 100, weight: .light))
                        .foregroundColor(Color.Teal.teal800)
                }

                Spacer()

                // MARK: Timer Display
                VStack(spacing: 4) {
                    if viewModel.isPaused {
                        Text("Total Time")
                            .font(Font.AppFont.textSecondary)
                            .foregroundColor(Color.ExerciseSemantic.playerTimerLabel)
                    }

                    Text(viewModel.formattedTime)
                        .font(Font.AppFont.title1)
                        .foregroundColor(Color.ExerciseSemantic.playerTimerText)
                }
                .padding(.bottom, 32)

                // MARK: Action Controls
                if viewModel.isPaused {
                    WorkoutPausedControlsView(viewModel: viewModel)
                } else {
                    WorkoutActiveControlsView(viewModel: viewModel) {
                        viewModel.showCancelAlert = true
                    }
                }
            }
            .background(Color.ExerciseSemantic.screenBackground.ignoresSafeArea())
            .navigationBarHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .hideCustomTabBar(true)

            // MARK: - Success Completion Dialog
            if viewModel.showSuccessDialog {
                SuccessDialog(
                    title: "Workout Completed!",
                    subtitle: "Great job! You completed \(viewModel.exercise.name) in \(viewModel.formattedTime) with \(viewModel.setsCount) set\(viewModel.setsCount > 1 ? "s" : "") and \(viewModel.repsCount) rep\(viewModel.repsCount > 1 ? "s" : "")."
                ) {
                    viewModel.showSuccessDialog = false
                    router.pop()
                }
                .transition(.opacity.combined(with: .scale))
                .zIndex(200)
            }
        }
        // MARK: - Cancel Confirmation Alert
        .customAlert(
            isPresented: $viewModel.showCancelAlert,
            type: .warning,
            title: "Cancel Workout?",
            description: "Are you sure you want to quit? Your current workout progress will be lost.",
            primaryButtonTitle: "End Workout",
            primaryButtonColor: Color.Red.red500,
            primaryAction: {
                viewModel.stopTimer()
                router.pop()
            },
            secondaryButtonTitle: "Keep Going",
            secondaryAction: {
                viewModel.showCancelAlert = false
            }
        )
        // MARK: - Restart Confirmation Alert
        .customAlert(
            isPresented: $viewModel.showRestartAlert,
            type: .warning,
            title: "Restart Timer?",
            description: "This will reset your workout timer back to 00:00.",
            primaryButtonTitle: "Restart",
            primaryButtonColor: Color.Teal.teal1000,
            primaryAction: {
                viewModel.restartTimer()
            },
            secondaryButtonTitle: "Cancel",
            secondaryAction: {
                viewModel.showRestartAlert = false
            }
        )
    }
}

// MARK: - Previews

#Preview("Light") {
    ExerciseWorkoutPlayerView(
        exercise: Exercise(
            id: "1",
            name: "Full Body Warm Up",
            equipment: "equipment",
            target: "target",
            category: "Warm Up",
            imageName: "figure.walk",
            instructions: "Sample instructions."
        )
    )
    .environmentObject(AppRouter())
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    ExerciseWorkoutPlayerView(
        exercise: Exercise(
            id: "1",
            name: "Full Body Warm Up",
            equipment: "equipment",
            target: "target",
            category: "Warm Up",
            imageName: "figure.walk",
            instructions: "Sample instructions."
        )
    )
    .environmentObject(AppRouter())
    .preferredColorScheme(.dark)
}
