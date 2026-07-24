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
                exerciseThumbnail
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

    // MARK: - Thumbnail
    @ViewBuilder
    private var exerciseThumbnail: some View {
        if let sfSymbol = exercise.imageName {
            Image(systemName: sfSymbol)
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(Color.Teal.teal800)
                .frame(width: 64, height: 64)
        } else {
            Image(systemName: "figure.mixed.cardio")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(Color.Teal.teal800)
                .frame(width: 64, height: 64)
        }
    }
}

#Preview {
    ExerciseRowCard(
        exercise: Exercise(
            id: "1",
            name: "Full Body Warm Up",
            equipment: "equipment",
            target: "target",
            category: "Warm Up",
            imageName: "figure.walk",
            instructions: "Sample instructions here."
        ),
        onTap: {}
    )
    .padding()
}
