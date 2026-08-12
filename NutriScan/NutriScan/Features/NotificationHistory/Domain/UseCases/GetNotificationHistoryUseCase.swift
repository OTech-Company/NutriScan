//
//  GetNotificationHistoryUseCase.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import Foundation

protocol GetNotificationHistoryUseCaseProtocol {
    func execute() -> [NotificationHistoryItem]
}

final class GetNotificationHistoryUseCase: GetNotificationHistoryUseCaseProtocol {
    private let repository: NotificationHistoryRepositoryProtocol

    init(repository: NotificationHistoryRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> [NotificationHistoryItem] {
        repository.getHistoryItems()
    }
}
