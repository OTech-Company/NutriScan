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
                .padding(.bottom, 20)

                // MARK: Exercise Title & Info
                VStack(spacing: 4) {
                    Text(viewModel.exercise.name)
                        .font(Font.AppFont.title3)
                        .foregroundColor(Color.ExerciseSemantic.rowTitle)
                        .multilineTextAlignment(.center)

                    Text("\(viewModel.exercise.equipment.capitalized)  •  \(viewModel.exercise.target.capitalized)")
                        .font(Font.AppFont.textSecondary)
                        .foregroundColor(Color.ExerciseSemantic.rowSubtitle)
                }
                .padding(.horizontal, 20)

                Spacer()

                // MARK: Illustration Circle & GIF Player
                ZStack {
                    Circle()
                        .fill(Color.ExerciseSemantic.playerCircleBg)
                        .frame(width: 260, height: 260)

                    CachedAnimatedImage(
                        urlString: viewModel.exercise.fullGifUrlString ?? viewModel.exercise.fullImageUrlString,
                        failureImageName: "figure.cross.training",
                        contentMode: .fit
                    )
                    .frame(width: 220, height: 220)
                    .clipShape(Circle())
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
                if viewModel.hasStarted && viewModel.isPaused {
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
        }
        // MARK: - Success Completion Alert
        .customAlert(
            isPresented: $viewModel.showSuccessDialog,
            type: .success,
            title: "Workout Completed!",
            description: "Great job! You completed \(viewModel.exercise.name) (\(viewModel.setsCount) sets x \(viewModel.repsCount) reps) in \(viewModel.formattedTime) and burned \(viewModel.formattedCalories) kcal.",
            primaryButtonTitle: "Done",
            primaryButtonColor: Color.Teal.teal1000,
            primaryAction: {
                viewModel.stopTimer()
                viewModel.showSuccessDialog = false
                router.pop()
            }
        )
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
            category: "Warm Up",
            bodyPart: "full body",
            equipment: "equipment",
            instructions: ExerciseInstructionText(en: "Sample instructions.", ar: ""),
            instructionSteps: ExerciseInstructionSteps(en: ["Sample step 1"], ar: []),
            target: "target",
            image: "figure.walk",
            gifUrl: "figure.walk"
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
            category: "Warm Up",
            bodyPart: "full body",
            equipment: "equipment",
            instructions: ExerciseInstructionText(en: "Sample instructions.", ar: ""),
            instructionSteps: ExerciseInstructionSteps(en: ["Sample step 1"], ar: []),
            target: "target",
            image: "figure.walk",
            gifUrl: "figure.walk"
        )
    )
    .environmentObject(AppRouter())
    .preferredColorScheme(.dark)
}
