//
//  MarkNotificationAsReadUseCase.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import Foundation

protocol MarkNotificationAsReadUseCaseProtocol {
    func execute(id: UUID)
}

final class MarkNotificationAsReadUseCase: MarkNotificationAsReadUseCaseProtocol {
    private let repository: NotificationHistoryRepositoryProtocol

    init(repository: NotificationHistoryRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: UUID) {
        repository.markAsRead(id: id)
    }
}
