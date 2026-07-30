//
//  UpdateWaterUseCase.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

final class UpdateWaterUseCase {
    private let repository: CaloriesTrackingRepo

    init(repository: CaloriesTrackingRepo) {
        self.repository = repository
    }

    func execute(
        date: String,
        targetWaterCnt: Int? = nil,
        waterCnt: Int? = nil,
        stepsCnt: Int? = nil,
        stepsKcal: Int? = nil,
        exerciseKcal: Int? = nil,
        exerciseMin: Double? = nil,
        totalMealKcal: Int? = nil
    ) async throws -> CaloriesTracking {
        try await repository.updateCaloriesTracking(
            date: date,
            targetWaterCnt: targetWaterCnt,
            waterCnt: waterCnt,
            stepsCnt: stepsCnt,
            stepsKcal: stepsKcal,
            exerciseKcal: exerciseKcal,
            exerciseMin: exerciseMin,
            totalMealKcal: totalMealKcal
        )
    }
}
