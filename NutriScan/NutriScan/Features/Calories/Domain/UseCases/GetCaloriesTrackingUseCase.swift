//
//  GetCaloriesTrackingUseCase.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

final class GetTodayCaloriesTrackingUseCase {
    private let repository: CaloriesTrackingRepo

    init(repository: CaloriesTrackingRepo) {
        self.repository = repository
    }

    func execute() async throws -> CaloriesTracking {
        try await repository.getTodayCaloriesTracking()
    }
}

final class GetCaloriesTrackingByDateUseCase {
    private let repository: CaloriesTrackingRepo

    init(repository: CaloriesTrackingRepo) {
        self.repository = repository
    }

    func execute(date: String) async throws -> CaloriesTracking {
        try await repository.getCaloriesTrackingByDate(date: date)
    }
}
