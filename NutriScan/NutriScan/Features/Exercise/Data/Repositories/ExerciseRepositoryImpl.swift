//
//  ExerciseRepositoryImpl.swift
//  NutriScan
//

import Foundation

final class ExerciseRepositoryImpl: ExerciseRepositoryProtocol {
    private let service: ExerciseService

    init(service: ExerciseService = ExerciseService()) {
        self.service = service
    }

    func fetchExercises(request: FetchExercisesRequest) async throws -> PaginatedExercisesResult {
        let response = try await service.fetchExercises(request: request)

        let exercises = response.data.map { $0.toDomain() }
        let pagination = response.meta.pagination

        return PaginatedExercisesResult(
            exercises: exercises,
            hasNext: pagination.hasNext,
            currentPage: pagination.currentPage,
            totalPages: pagination.totalPages
        )
    }

    func fetchCategories() async throws -> [ExerciseCategory] {
        let dto = try await service.fetchCategories()
        return dto.toDomain()
    }
}
