//
//  NotificationHistoryRoute.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import SwiftUI

enum NotificationHistoryRoute: Route {
    case notificationHistory

    @MainActor @ViewBuilder
    var destination: some View {
        switch self {
        case .notificationHistory:
            NotificationHistoryFactory.makeNotificationHistoryView()
        }
    }
}
