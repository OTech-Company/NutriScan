//
//  NotificationHistoryRepositoryProtocol.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import Foundation

protocol NotificationHistoryRepositoryProtocol {
    func getHistoryItems() -> [NotificationHistoryItem]
    func saveItem(_ item: NotificationHistoryItem)
    func deleteItem(id: UUID)
    func clearAll()
    func markAsRead(id: UUID)
}
