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
