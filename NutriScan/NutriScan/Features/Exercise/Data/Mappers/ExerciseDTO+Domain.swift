//
//  ExerciseDTO+Domain.swift
//  NutriScan
//

import Foundation

extension ExerciseDTO {
    func toDomain() -> Exercise {
        let enText = instructions["en"] ?? ""
        let arText = instructions["ar"] ?? ""
        let localizedText = ExerciseInstructionText(en: enText, ar: arText)

        let enSteps = instructionSteps["en"] ?? []
        let arSteps = instructionSteps["ar"] ?? []
        let localizedSteps = ExerciseInstructionSteps(en: enSteps, ar: arSteps)

        return Exercise(
            id: id,
            name: name,
            category: category,
            bodyPart: bodyPart,
            equipment: equipment,
            instructions: localizedText,
            instructionSteps: localizedSteps,
            muscleGroup: muscleGroup,
            secondaryMuscles: secondaryMuscles,
            target: target,
            repKcal: repKcal,
            minKcal: minKcal,
            mediaId: mediaId,
            image: image,
            gifUrl: gifUrl,
            attribution: attribution,
            createdAt: createdAt
        )
    }
}
