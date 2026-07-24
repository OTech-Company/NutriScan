//
//  FetchExerciseCategoriesUseCase.swift
//  NutriScan
//

import Foundation

struct FetchExerciseCategoriesUseCase {
    private let repository: ExerciseRepositoryProtocol

    init(repository: ExerciseRepositoryProtocol = ExerciseRepositoryImpl()) {
        self.repository = repository
    }

    func execute() async throws -> [ExerciseCategory] {
        try await repository.fetchCategories()
    }
}
