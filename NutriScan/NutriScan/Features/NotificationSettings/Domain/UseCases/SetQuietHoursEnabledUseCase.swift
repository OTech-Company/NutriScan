//
//  SetQuietHoursEnabledUseCase.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import Foundation

protocol SetQuietHoursEnabledUseCaseProtocol {
    func execute(enabled: Bool)
}

final class SetQuietHoursEnabledUseCase: SetQuietHoursEnabledUseCaseProtocol {
    private let repository: NotificationPreferencesRepositoryProtocol

    init(repository: NotificationPreferencesRepositoryProtocol) {
        self.repository = repository
    }

    func execute(enabled: Bool) {
        repository.setQuietHoursEnabled(enabled)
    }
}
