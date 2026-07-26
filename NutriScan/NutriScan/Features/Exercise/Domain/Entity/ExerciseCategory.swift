//
//  ExerciseCategory.swift
//  NutriScan
//

import Foundation

struct ExerciseCategory: Identifiable, Hashable, Equatable {
    let id: String
    let name: String

    static let all = ExerciseCategory(id: "all", name: "All")
}

// MARK: - Dummy Placeholders

extension ExerciseCategory {
    static let dummyList: [ExerciseCategory] = [
        ExerciseCategory(id: "d1", name: "Warm Up"),
        ExerciseCategory(id: "d2", name: "Strength"),
        ExerciseCategory(id: "d3", name: "Cardio"),
        ExerciseCategory(id: "d4", name: "Flexibility"),
        ExerciseCategory(id: "d5", name: "Core"),
    ]
}
