//
//  NotificationHistoryLocalDataSource.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import Foundation
import SwiftData

protocol NotificationHistoryLocalDataSourceProtocol {
    func fetchItems() -> [NotificationHistoryItem]
    func saveItem(_ item: NotificationHistoryItem)
    func deleteItem(id: UUID)
    func clearAll()
    func markAsRead(id: UUID)
}

final class NotificationHistoryLocalDataSource: NotificationHistoryLocalDataSourceProtocol {
    private let container: ModelContainer
    private let context: ModelContext

    init() {
        do {
            let schema = Schema([NotificationHistorySDModel.self])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            self.container = try ModelContainer(for: schema, configurations: [config])
            self.context = ModelContext(container)
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
        seedInitialMockDataIfNeeded()
    }

    func fetchItems() -> [NotificationHistoryItem] {
        let descriptor = FetchDescriptor<NotificationHistorySDModel>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        let models = (try? context.fetch(descriptor)) ?? []
        return models.map { $0.toDomain() }
    }

    func saveItem(_ item: NotificationHistoryItem) {
        let sdModel = NotificationHistorySDModel(
            id: item.id,
            title: item.title,
            body: item.body,
            categoryRawValue: item.category.rawValue,
            timestamp: item.timestamp,
            isRead: item.isRead
        )
        context.insert(sdModel)
        try? context.save()
    }

    func deleteItem(id: UUID) {
        let descriptor = FetchDescriptor<NotificationHistorySDModel>(
            predicate: #Predicate { $0.id == id }
        )
        if let models = try? context.fetch(descriptor) {
            for model in models {
                context.delete(model)
            }
            try? context.save()
        }
    }

    func clearAll() {
        do {
            try context.delete(model: NotificationHistorySDModel.self)
            try context.save()
        } catch {
            print("Failed to clear SwiftData notification history: \(error)")
        }
    }

    func markAsRead(id: UUID) {
        let descriptor = FetchDescriptor<NotificationHistorySDModel>(
            predicate: #Predicate { $0.id == id }
        )
        if let models = try? context.fetch(descriptor), let item = models.first {
            item.isRead = true
            try? context.save()
        }
    }

    private func seedInitialMockDataIfNeeded() {
        let descriptor = FetchDescriptor<NotificationHistorySDModel>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        if count == 0 {
            let now = Date()
            let mockItems: [NotificationHistoryItem] = [
                NotificationHistoryItem(
                    title: "Time for a break",
                    body: "Stand up, stretch, drink some water, and rest your eyes for a ...",
                    category: .breakTime,
                    timestamp: now.addingTimeInterval(-3600),
                    isRead: false
                ),
                NotificationHistoryItem(
                    title: "Stay hydrated",
                    body: "You're at 0/8 glasses today.",
                    category: .water,
                    timestamp: now.addingTimeInterval(-3600),
                    isRead: false
                ),
                NotificationHistoryItem(
                    title: "Keep going",
                    body: "You're at 2/10000 steps today.",
                    category: .steps,
                    timestamp: now.addingTimeInterval(-3600),
                    isRead: true
                ),
                NotificationHistoryItem(
                    title: "Stay hydrated",
                    body: "You're at 0/8 glasses today.",
                    category: .water,
                    timestamp: now.addingTimeInterval(-10800),
                    isRead: true
                ),
                NotificationHistoryItem(
                    title: "Time for a break",
                    body: "Stand up, stretch, drink some water, and rest your eyes for a ...",
                    category: .breakTime,
                    timestamp: now.addingTimeInterval(-10800),
                    isRead: true
                ),
                NotificationHistoryItem(
                    title: "Stay hydrated",
                    body: "You're at 0/8 glasses today.",
                    category: .water,
                    timestamp: now.addingTimeInterval(-25200),
                    isRead: true
                )
            ]
            for item in mockItems {
                saveItem(item)
            }
        }
    }
}
