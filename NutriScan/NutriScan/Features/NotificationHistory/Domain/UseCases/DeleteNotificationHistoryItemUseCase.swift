//
//  DeleteNotificationHistoryItemUseCase.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import Foundation

protocol DeleteNotificationHistoryItemUseCaseProtocol {
    func execute(id: UUID)
}

final class DeleteNotificationHistoryItemUseCase: DeleteNotificationHistoryItemUseCaseProtocol {
    private let repository: NotificationHistoryRepositoryProtocol

    init(repository: NotificationHistoryRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: UUID) {
        repository.deleteItem(id: id)
    }
}
