//
//  ClearNotificationHistoryUseCase.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import Foundation

protocol ClearNotificationHistoryUseCaseProtocol {
    func execute()
}

final class ClearNotificationHistoryUseCase: ClearNotificationHistoryUseCaseProtocol {
    private let repository: NotificationHistoryRepositoryProtocol

    init(repository: NotificationHistoryRepositoryProtocol) {
        self.repository = repository
    }

    func execute() {
        repository.clearAll()
    }
}
