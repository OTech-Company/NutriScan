//
//  GetCaloriesTrackingUseCase.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

protocol GetTodayCaloriesTrackingUseCaseProtocol {
    func execute() async throws -> CaloriesTracking
}

protocol GetCaloriesTrackingByDateUseCaseProtocol {
    func execute(date: String) async throws -> CaloriesTracking
}

final class GetTodayCaloriesTrackingUseCase: GetTodayCaloriesTrackingUseCaseProtocol {
    private let repository: CaloriesTrackingRepo

    init(repository: CaloriesTrackingRepo) {
        self.repository = repository
    }

    func execute() async throws -> CaloriesTracking {
        try await repository.getTodayCaloriesTracking()
    }
}

final class GetCaloriesTrackingByDateUseCase: GetCaloriesTrackingByDateUseCaseProtocol {
    private let repository: CaloriesTrackingRepo

    init(repository: CaloriesTrackingRepo) {
        self.repository = repository
    }

    func execute(date: String) async throws -> CaloriesTracking {
        try await repository.getCaloriesTrackingByDate(date: date)
    }
}
