//
//  GetQuietHoursUseCase.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import Foundation

struct QuietHoursInfo {
    let isEnabled: Bool
    let timeRangeString: String
}

protocol GetQuietHoursUseCaseProtocol {
    func execute() -> QuietHoursInfo
}

final class GetQuietHoursUseCase: GetQuietHoursUseCaseProtocol {
    private let repository: NotificationPreferencesRepositoryProtocol

    init(repository: NotificationPreferencesRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> QuietHoursInfo {
        QuietHoursInfo(
            isEnabled: repository.isQuietHoursEnabled,
            timeRangeString: repository.quietHoursTimeString
        )
    }
}
