//
//  ExerciseDetailSheet.swift
//  NutriScan
//

import SwiftUI

struct ExerciseDetailSheet: View {
    let exercise: Exercise
    var onStartWorkout: () -> Void = {}

    @State private var isExpanded: Bool = false

    // Truncate instructions at 3 lines when collapsed
    private let collapsedLineLimit = 3

    var body: some View {
        VStack(spacing: 0) {

            // MARK: Drag Handle
            Capsule()
                .fill(Color.ExerciseSemantic.sheetHandle)
                .frame(width: 40, height: 4)
                .padding(.top, 12)
                .padding(.bottom, 20)

            // MARK: Exercise Header
            HStack(spacing: 16) {
                // Thumbnail
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.Teal.teal200.opacity(0.5))
                        .frame(width: 72, height: 72)

                    Image(systemName: exercise.imageName ?? "figure.mixed.cardio")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(Color.Teal.teal800)
                }

                // Name + subtitle
                VStack(alignment: .leading, spacing: 6) {
                    Text(exercise.name)
                        .font(Font.AppFont.textPrimary)
                        .foregroundColor(Color.ExerciseSemantic.sheetTitle)

                    Text("\(exercise.equipment)  •  \(exercise.target)")
                        .font(Font.AppFont.textSecondary)
                        .foregroundColor(Color.ExerciseSemantic.sheetSubtitle)
                }

                Spacer()
            }
            .padding(.horizontal, 20)

            // MARK: Divider
            Rectangle()
                .fill(Color.Teal.teal200.opacity(0.6))
                .frame(height: 1)
                .padding(.horizontal, 20)
                .padding(.vertical, 20)

            // MARK: Instructions
            VStack(alignment: .leading, spacing: 12) {
                Text("Instructions")
                    .font(Font.AppFont.subtitle1)
                    .foregroundColor(Color.ExerciseSemantic.instructionHead)

                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .font(Font.AppFont.textDefault)
                            .foregroundColor(Color.ExerciseSemantic.instructionText)

                        Text(exercise.instructions)
                            .font(Font.AppFont.textSecondary)
                            .foregroundColor(Color.ExerciseSemantic.instructionText)
                            .lineLimit(isExpanded ? nil : collapsedLineLimit)
                            .animation(.easeInOut(duration: 0.25), value: isExpanded)
                    }

                    // Read more / read less toggle
                    if !isExpanded {
                        Button {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                isExpanded = true
                            }
                        } label: {
                            Text("read more")
                                .font(Font.AppFont.textSecondary)
                                .foregroundColor(Color.ExerciseSemantic.readMoreText)
                        }
                        .padding(.leading, 16)
                    }
                }
            }
            .padding(.horizontal, 20)

            // MARK: CTA — Start Workout
            CustomPuffedButton(title: "Start Workout", action: onStartWorkout)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity)
        .background(Color.ExerciseSemantic.sheetBackground)
    }
}

// MARK: - Previews

#Preview("Light") {
    Color.gray.opacity(0.3)
        .ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            ExerciseDetailSheet(
                exercise: Exercise(
                    id: "4",
                    name: "3/4 sit-up",
                    equipment: "body weight",
                    target: "waist",
                    category: "Core",
                    imageName: "figure.core.training",
                    instructions: "Lie flat on your back with your knees bent and feet flat on the ground. Place your hands behind your head with your elbows pointing outwards. Engaging your abs, slowly lift your upper body off the ground, curling forward until your torso is at a 45-degree angle. Pause for a moment at the top, then slowly lower your upper body back down to the starting position. Repeat for the desired number of repetitions."
                )
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.hidden)
            .presentationCornerRadius(24)
            .presentationBackground(Color.ExerciseSemantic.sheetBackground)
        }
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    Color.gray.opacity(0.3)
        .ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            ExerciseDetailSheet(
                exercise: Exercise(
                    id: "4",
                    name: "3/4 sit-up",
                    equipment: "body weight",
                    target: "waist",
                    category: "Core",
                    imageName: "figure.core.training",
                    instructions: "Lie flat on your back with your knees bent and feet flat on the ground. Place your hands behind your head with your elbows pointing outwards. Engaging your abs, slowly lift your upper body off the ground, curling forward until your torso is at a 45-degree angle. Pause for a moment at the top, then slowly lower your upper body back down to the starting position. Repeat for the desired number of repetitions."
                )
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.hidden)
            .presentationCornerRadius(24)
            .presentationBackground(Color.ExerciseSemantic.sheetBackground)
        }
        .preferredColorScheme(.dark)
}
