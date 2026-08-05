//
//  DeleteMealUseCase.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

protocol DeleteMealUseCaseProtocol {
    func execute(date: String, scanId: String) async throws
}

final class DeleteMealUseCase: DeleteMealUseCaseProtocol {
    private let repository: CaloriesTrackingRepo

    init(repository: CaloriesTrackingRepo) {
        self.repository = repository
    }

    func execute(date: String, scanId: String) async throws {
        try await repository.deleteMeal(date: date, scanId: scanId)
    }
}
