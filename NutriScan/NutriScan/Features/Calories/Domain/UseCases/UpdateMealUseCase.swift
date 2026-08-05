//
//  UpdateMealUseCase.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

protocol UpdateMealUseCaseProtocol {
    func execute(date: String, scanId: String, mealCnt: Int) async throws -> CalorieMeal
}

final class UpdateMealUseCase: UpdateMealUseCaseProtocol {
    private let repository: CaloriesTrackingRepo

    init(repository: CaloriesTrackingRepo) {
        self.repository = repository
    }

    func execute(date: String, scanId: String, mealCnt: Int) async throws -> CalorieMeal {
        try await repository.updateMealCount(date: date, scanId: scanId, mealCnt: mealCnt)
    }
}
