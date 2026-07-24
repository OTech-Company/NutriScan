//
//  Exercise.swift
//  NutriScan
//

import Foundation

struct Exercise: Identifiable, Hashable, Equatable {
    let id: String
    let name: String
    let category: String
    let bodyPart: String
    let equipment: String
    let instructions: ExerciseInstructionText
    let instructionSteps: ExerciseInstructionSteps
    let muscleGroup: String
    let secondaryMuscles: [String]
    let target: String
    let repKcal: Double?
    let minKcal: Double?
    let mediaId: String
    let image: String
    let gifUrl: String
    let attribution: String
    let createdAt: String

    init(
        id: String,
        name: String,
        category: String,
        bodyPart: String = "",
        equipment: String,
        instructions: ExerciseInstructionText = ExerciseInstructionText(en: "", ar: ""),
        instructionSteps: ExerciseInstructionSteps = ExerciseInstructionSteps(en: [], ar: []),
        muscleGroup: String = "",
        secondaryMuscles: [String] = [],
        target: String,
        repKcal: Double? = nil,
        minKcal: Double? = nil,
        mediaId: String = "",
        image: String = "",
        gifUrl: String = "",
        attribution: String = "",
        createdAt: String = ""
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.bodyPart = bodyPart
        self.equipment = equipment
        self.instructions = instructions
        self.instructionSteps = instructionSteps
        self.muscleGroup = muscleGroup
        self.secondaryMuscles = secondaryMuscles
        self.target = target
        self.repKcal = repKcal
        self.minKcal = minKcal
        self.mediaId = mediaId
        self.image = image
        self.gifUrl = gifUrl
        self.attribution = attribution
        self.createdAt = createdAt
    }

    /// Complete HTTP URL for static exercise image
    var fullImageUrlString: String? {
        guard !image.isEmpty else { return nil }
        if image.hasPrefix("http://") || image.hasPrefix("https://") {
            return image
        }
        let base = AppNetworkConfig.exercises.baseURL
        let cleanPath = image.hasPrefix("/") ? String(image.dropFirst()) : image
        return "\(base)/\(cleanPath)"
    }

    /// Complete HTTP URL for animated exercise GIF
    var fullGifUrlString: String? {
        guard !gifUrl.isEmpty else { return nil }
        if gifUrl.hasPrefix("http://") || gifUrl.hasPrefix("https://") {
            return gifUrl
        }
        let base = AppNetworkConfig.exercises.baseURL
        let cleanPath = gifUrl.hasPrefix("/") ? String(gifUrl.dropFirst()) : gifUrl
        return "\(base)/\(cleanPath)"
    }

    /// Formatted instruction text string for display
    var formattedInstructions: String {
        if !instructionSteps.localizedSteps.isEmpty {
            return instructionSteps.localizedSteps.joined(separator: "\n")
        }
        if !instructions.localizedText.isEmpty {
            return instructions.localizedText
        }
        return "Follow proper form and control your breathing during each movement."
    }
}

// MARK: - Dummy Placeholders

extension Exercise {
    static let dummyList: [Exercise] = (1...6).map { index in
        Exercise(
            id: "dummy_\(index)",
            name: "Loading Exercise Name",
            category: "Category",
            bodyPart: "Body Part",
            equipment: "Equipment",
            instructions: ExerciseInstructionText(en: "Loading instruction text placeholder...", ar: ""),
            instructionSteps: ExerciseInstructionSteps(en: ["Loading step placeholder"], ar: []),
            target: "Target Muscle"
        )
    }
}
