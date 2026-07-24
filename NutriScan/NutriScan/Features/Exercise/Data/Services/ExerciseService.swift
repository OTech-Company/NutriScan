//
//  ExerciseService.swift
//  NutriScan
//

import Foundation

struct ExerciseService {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }

    func fetchCategories() async throws -> CategoryResponseDTO {
        try await networkService.request(ExerciseEndpoint.getCategories)
    }

    func fetchExercises(request: FetchExercisesRequest) async throws -> ExerciseResponseDTO {
        try await networkService.request(ExerciseEndpoint.getExercises(request: request))
    }
}
