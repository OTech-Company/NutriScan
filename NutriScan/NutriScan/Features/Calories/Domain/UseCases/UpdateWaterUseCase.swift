//
//  UpdateWaterUseCase.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

protocol UpdateWaterUseCaseProtocol {
    func execute(
        date: String,
        targetWaterCnt: Int?,
        waterCnt: Int?,
        stepsCnt: Int?,
        stepsKcal: Double?,
        exerciseKcal: Double?,
        exerciseMin: Double?
    ) async throws -> CaloriesTracking
}

final class UpdateWaterUseCase: UpdateWaterUseCaseProtocol {
    private let repository: CaloriesTrackingRepo

    init(repository: CaloriesTrackingRepo) {
        self.repository = repository
    }

    func execute(
        date: String,
        targetWaterCnt: Int? = nil,
        waterCnt: Int? = nil,
        stepsCnt: Int? = nil,
        stepsKcal: Double? = nil,
        exerciseKcal: Double? = nil,
        exerciseMin: Double? = nil
    ) async throws -> CaloriesTracking {
        try await repository.updateCaloriesTracking(
            date: date,
            targetWaterCnt: targetWaterCnt,
            waterCnt: waterCnt,
            stepsCnt: stepsCnt,
            stepsKcal: stepsKcal,
            exerciseKcal: exerciseKcal,
            exerciseMin: exerciseMin
        )
    }
}
