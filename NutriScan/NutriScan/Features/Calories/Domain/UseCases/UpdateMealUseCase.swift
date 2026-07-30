//
//  UpdateMealUseCase.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

final class UpdateMealUseCase {
    private let repository: CaloriesTrackingRepo

    init(repository: CaloriesTrackingRepo) {
        self.repository = repository
    }

    func execute(date: String, scanId: String, mealCnt: Int) async throws -> CalorieMeal {
        try await repository.updateMealCount(date: date, scanId: scanId, mealCnt: mealCnt)
    }
}
