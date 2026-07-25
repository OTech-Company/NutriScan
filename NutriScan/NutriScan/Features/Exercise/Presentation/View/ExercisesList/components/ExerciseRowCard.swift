//
//  ExerciseRowCard.swift
//  NutriScan
//

import SwiftUI

struct ExerciseRowCard: View {
    let exercise: Exercise
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {

                // MARK: Thumbnail
                CachedImage(
                    urlString: exercise.fullImageUrlString,
                    failureImageName: "figure.mixed.cardio",
                    contentMode: .fit
                )
                .frame(width: 64, height: 64)
                    .frame(width: 64, height: 64)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.Teal.teal200.opacity(0.5))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                // MARK: Text
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.name)
                        .font(Font.AppFont.lexendDecaMedium16)
                        .foregroundColor(Color.ExerciseSemantic.rowTitle)
                        .lineLimit(1)

                    Text("\(exercise.equipment)  •  \(exercise.target)")
                        .font(Font.AppFont.textSecondary)
                        .foregroundColor(Color.ExerciseSemantic.rowSubtitle)
                        .lineLimit(1)
                }

                Spacer()

                // MARK: Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.ExerciseSemantic.rowChevron)
            }
            .padding(.horizontal, 16)
            .frame(height: 88)
            .background(Color.ExerciseSemantic.cardBackground)
            .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ExerciseRowCard(
        exercise: Exercise(
            id: "1",
            name: "Full Body Warm Up",
            category: "Warm Up",
            bodyPart: "full body",
            equipment: "equipment",
            instructions: ExerciseInstructionText(en: "Sample instructions here.", ar: ""),
            instructionSteps: ExerciseInstructionSteps(en: ["Sample step 1"], ar: []),
            target: "target"
        ),
        onTap: {}
    )
    .padding()
}
