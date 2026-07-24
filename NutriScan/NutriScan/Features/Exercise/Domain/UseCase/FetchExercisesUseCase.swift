//
//  FetchExercisesUseCase.swift
//  NutriScan
//

import Foundation

struct FetchExercisesUseCase {
    private let repository: ExerciseRepositoryProtocol

    init(repository: ExerciseRepositoryProtocol = ExerciseRepositoryImpl()) {
        self.repository = repository
    }

    func execute(request: FetchExercisesRequest = FetchExercisesRequest()) async throws -> PaginatedExercisesResult {
        try await repository.fetchExercises(request: request)
    }
}
