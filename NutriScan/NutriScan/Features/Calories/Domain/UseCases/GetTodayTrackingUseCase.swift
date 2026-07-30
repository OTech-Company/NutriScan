//
//  GetTodayTrackingUseCase.swift
//  NutriScan
//
//  Created by albaraa alsayed on 28/07/2026.
//

import Foundation

final class GetTodayTrackingUseCase {
    private let repository: DailyTrackingRepo

    init(repository: DailyTrackingRepo) {
        self.repository = repository
    }

    func execute() async throws -> DailyTracking {
        try await repository.getTodayTracking()
    }
}

final class GetTrackingByDateUseCase {
    private let repository: DailyTrackingRepo

    init(repository: DailyTrackingRepo) {
        self.repository = repository
    }

    func execute(date: String) async throws -> DailyTracking {
        try await repository.getTrackingByDate(date: date)
    }
}
