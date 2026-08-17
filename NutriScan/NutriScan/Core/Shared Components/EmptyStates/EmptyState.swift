//
//  EmptyState.swift
//  NutriScan
//
//  Created by albaraa alsayed on 17/02/1448 AH.
//

import Foundation

enum EmptyState {
    case noConnection, error404, noScans, noNotificationPermission, noNotifications, noSaved, noSearchResults, noCaloriesHistory, serverProblem
    
    var title: String {
        switch self {
        case .noConnection:
            return LocalizationKeys.EmptyState.titleNoConnection.localized
        case .error404:
            return LocalizationKeys.EmptyState.titleError404.localized
        case .noScans:
            return LocalizationKeys.EmptyState.titleNoScans.localized
        case .noNotificationPermission:
            return LocalizationKeys.EmptyState.titleNotificationPermission.localized
        case .noNotifications:
            return LocalizationKeys.EmptyState.titleNoNotifications.localized
        case .noSaved:
            return LocalizationKeys.EmptyState.titleNoSaved.localized
        case .noSearchResults:
            return LocalizationKeys.EmptyState.titleNoSearchResults.localized
        case .noCaloriesHistory:
            return LocalizationKeys.EmptyState.titleNoCaloriesHistory.localized
        case .serverProblem:
            return LocalizationKeys.EmptyState.titleServerProblem.localized
        }
    }
    
    var description: String {
        switch self {
        case .noConnection:
            return LocalizationKeys.EmptyState.descNoConnection.localized
        case .error404:
            return LocalizationKeys.EmptyState.descError404.localized
        case .noScans:
            return LocalizationKeys.EmptyState.descNoScans.localized
        case .noNotificationPermission:
            return LocalizationKeys.EmptyState.descNotificationPermission.localized
        case .noNotifications:
            return LocalizationKeys.EmptyState.descNoNotifications.localized
        case .noSaved:
            return LocalizationKeys.EmptyState.descNoSaved.localized
        case .noSearchResults:
            return LocalizationKeys.EmptyState.descNoSearchResults.localized
        case .noCaloriesHistory:
            return LocalizationKeys.EmptyState.descNoCaloriesHistory.localized
        case .serverProblem:
            return LocalizationKeys.EmptyState.descServerProblem.localized
        }
    }
    
    var image: String {
        switch self {
        case .noConnection:
            return "noConnectionPlaceholder"
        case .error404:
            return "error404placeholder"
        case .noScans:
            return "noScansPlaceholder"
        case .noNotificationPermission:
            return "notificationPermissionPlaceholder"
        case .noNotifications:
            return "notificationsPlaceholder"
        case .noSaved:
            return "savedPlaceholder"
        case .noSearchResults:
            return "searchPlaceHolder"
        case .noCaloriesHistory:
            return "noCaloriesHistory"
        case .serverProblem:
            return "serverProblem"
        }
    }
    
    var actionLabel: String {
        switch self {
        case .error404:
            return LocalizationKeys.EmptyState.actionGoToHome.localized
        case .noScans:
            return LocalizationKeys.EmptyState.actionStartScanning.localized
        case .noNotificationPermission:
            return LocalizationKeys.EmptyState.actionGoToSettings.localized
        case .noNotifications:
            return LocalizationKeys.EmptyState.actionGoBack.localized
        case .noSaved:
            return LocalizationKeys.EmptyState.actionGoToScans.localized
        case .noSearchResults:
            return LocalizationKeys.ScanHistory.clearSearch.localized
        case .noCaloriesHistory:
            return LocalizationKeys.EmptyState.actionAddMeals.localized
        case .serverProblem, .noConnection:
            return LocalizationKeys.EmptyState.actionTryAgain.localized
        }
    }
}
