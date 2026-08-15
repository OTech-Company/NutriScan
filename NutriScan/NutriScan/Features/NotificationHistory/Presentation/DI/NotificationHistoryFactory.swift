//
//  NotificationHistoryFactory.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import SwiftUI

@MainActor
enum NotificationHistoryFactory {
    static func makeNotificationHistoryViewModel() -> NotificationHistoryViewModel {
        NotificationHistoryViewModel(
            getHistoryUseCase: DIContainer.shared.resolve(type: GetNotificationHistoryUseCaseProtocol.self),
            clearHistoryUseCase: DIContainer.shared.resolve(type: ClearNotificationHistoryUseCaseProtocol.self),
            deleteItemUseCase: DIContainer.shared.resolve(type: DeleteNotificationHistoryItemUseCaseProtocol.self),
            markAsReadUseCase: DIContainer.shared.resolve(type: MarkNotificationAsReadUseCaseProtocol.self)
        )
    }

    static func makeNotificationHistoryView() -> NotificationHistoryView {
        let viewModel = makeNotificationHistoryViewModel()
        return NotificationHistoryView(viewModel: viewModel)
    }
}
