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
                            viewModel.alert = .cancel
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
                        viewModel.alert = .cancel
                    }
                }
            }
            .background(Color.ExerciseSemantic.screenBackground.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .customAlert(
            item: $viewModel.alert,
            config: { alert in
                switch alert {
                case .success:
                    return CustomAlertConfig(
                        type: .success,
                        title: "Workout Completed!",
                        message: viewModel.completionDescription,
                        primaryButton: CustomAlertButton("Done")
                    )
                case .recordingError:
                    return CustomAlertConfig(
                        type: .error,
                        title: viewModel.hasRecordedWorkout ? "Workout Saved Locally" : "Unable to Save Workout",
                        message: viewModel.recordingErrorMessage
                    )
                case .cancel:
                    return CustomAlertConfig(
                        type: .warning,
                        title: "Cancel Workout?",
                        message: "Are you sure you want to quit? Your current workout progress will be lost.",
                        primaryButton: CustomAlertButton("End Workout", role: .destructive),
                        secondaryButton: CustomAlertButton("Keep Going", role: .cancel)
                    )
                case .restart:
                    return CustomAlertConfig(
                        type: .warning,
                        title: "Restart Timer?",
                        message: "This will reset your workout timer back to 00:00.",
                        primaryButton: CustomAlertButton("Restart"),
                        secondaryButton: CustomAlertButton("Cancel", role: .cancel)
                    )
                }
            },
            primaryAction: { alert in
                switch alert {
                case .success:
                    viewModel.stopTimer()
                    router.pop()
                case .recordingError:
                    break
                case .cancel:
                    viewModel.stopTimer()
                    router.pop()
                case .restart:
                    viewModel.restartTimer()
                }
            },
            secondaryAction: { _ in }
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
