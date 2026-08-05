//
//  SaveNotificationHistoryItemUseCase.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import Foundation

protocol SaveNotificationHistoryItemUseCaseProtocol {
    func execute(_ item: NotificationHistoryItem)
}

final class SaveNotificationHistoryItemUseCase: SaveNotificationHistoryItemUseCaseProtocol, NotificationHistorySaving {
    private let repository: NotificationHistoryRepositoryProtocol

    init(repository: NotificationHistoryRepositoryProtocol) {
        self.repository = repository
    }

    func execute(_ item: NotificationHistoryItem) {
        repository.saveItem(item)
    }

    func saveItem(_ item: NotificationHistoryItem) {
        execute(item)
    }
}
