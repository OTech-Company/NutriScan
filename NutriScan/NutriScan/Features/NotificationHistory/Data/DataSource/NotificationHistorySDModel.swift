//
//  NotificationHistorySDModel.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import Foundation
import SwiftData

@Model
final class NotificationHistorySDModel {
    @Attribute(.unique) var id: UUID
    var title: String
    var body: String
    var categoryRawValue: String
    var timestamp: Date
    var isRead: Bool

    init(
        id: UUID = UUID(),
        title: String,
        body: String,
        categoryRawValue: String,
        timestamp: Date = Date(),
        isRead: Bool = false
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.categoryRawValue = categoryRawValue
        self.timestamp = timestamp
        self.isRead = isRead
    }

    /// Converts SwiftData model to domain entity
    func toDomain() -> NotificationHistoryItem {
        let category = NotificationCategory(rawValue: categoryRawValue) ?? .breakTime
        return NotificationHistoryItem(
            id: id,
            title: title,
            body: body,
            category: category,
            timestamp: timestamp,
            isRead: isRead
        )
    }
}
