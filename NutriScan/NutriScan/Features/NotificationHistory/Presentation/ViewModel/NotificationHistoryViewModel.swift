//
//  NotificationHistoryViewModel.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import Foundation
import Combine

@MainActor
final class NotificationHistoryViewModel: ObservableObject {
    @Published var items: [NotificationHistoryItem] = []
    @Published var showClearAllAlert: Bool = false

    private let getHistoryUseCase: GetNotificationHistoryUseCaseProtocol
    private let clearHistoryUseCase: ClearNotificationHistoryUseCaseProtocol
    private let deleteItemUseCase: DeleteNotificationHistoryItemUseCaseProtocol
    private let markAsReadUseCase: MarkNotificationAsReadUseCaseProtocol

    init(
        getHistoryUseCase: GetNotificationHistoryUseCaseProtocol,
        clearHistoryUseCase: ClearNotificationHistoryUseCaseProtocol,
        deleteItemUseCase: DeleteNotificationHistoryItemUseCaseProtocol,
        markAsReadUseCase: MarkNotificationAsReadUseCaseProtocol
    ) {
        self.getHistoryUseCase = getHistoryUseCase
        self.clearHistoryUseCase = clearHistoryUseCase
        self.deleteItemUseCase = deleteItemUseCase
        self.markAsReadUseCase = markAsReadUseCase
    }

    func loadHistory() {
        items = getHistoryUseCase.execute()
    }

    func markAsRead(id: UUID) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        if !items[index].isRead {
            items[index].isRead = true
            markAsReadUseCase.execute(id: id)
        }
    }

    func deleteSingleItem(id: UUID) {
        deleteItemUseCase.execute(id: id)
        items.removeAll(where: { $0.id == id })
    }

    func requestClearAll() {
        guard !items.isEmpty else { return }
        showClearAllAlert = true
    }

    func confirmClearAll() {
        clearHistoryUseCase.execute()
        items.removeAll()
        showClearAllAlert = false
    }
}
