//
//  ExerciseRepositoryImpl.swift
//  NutriScan
//

final class ExerciseRepositoryImpl: ExerciseRepositoryProtocol {
    private let service: ExerciseService

    init(service: ExerciseService = ExerciseService()) {
        self.service = service
    }

    func fetchExercises() async throws -> [Exercise] {
        let dtos = try await service.fetchExercises()
        return dtos.map { $0.toDomain() }
    }

    func fetchCategories() async throws -> [ExerciseCategory] {
        let dto = try await service.fetchCategories()
        return dto.toDomain()
    }
}
