//
//  NotificationHistoryRepositoryImpl.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import Foundation

final class NotificationHistoryRepositoryImpl: NotificationHistoryRepositoryProtocol {
    private let dataSource: NotificationHistoryLocalDataSourceProtocol

    init(dataSource: NotificationHistoryLocalDataSourceProtocol = NotificationHistoryLocalDataSource()) {
        self.dataSource = dataSource
    }

    func getHistoryItems() -> [NotificationHistoryItem] {
        dataSource.fetchItems()
    }

    func saveItem(_ item: NotificationHistoryItem) {
        dataSource.saveItem(item)
    }

    func deleteItem(id: UUID) {
        dataSource.deleteItem(id: id)
    }

    func clearAll() {
        dataSource.clearAll()
    }

    func markAsRead(id: UUID) {
        dataSource.markAsRead(id: id)
    }
}
