//
//  UpdateWaterUseCase.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

final class UpdateWaterUseCase {
    private let repository: DailyTrackingRepo

    init(repository: DailyTrackingRepo) {
        self.repository = repository
    }

    func execute(date: String, targetWaterCnt: Int? = nil, waterCnt: Int? = nil, stepsCnt: Int? = nil) async throws {
        try await repository.updateWaterAndSteps(
            date: date,
            targetWaterCnt: targetWaterCnt,
            waterCnt: waterCnt,
            stepsCnt: stepsCnt
        )
    }
}
