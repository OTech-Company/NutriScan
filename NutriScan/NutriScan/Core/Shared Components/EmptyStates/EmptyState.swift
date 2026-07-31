//
//  EmptyState.swift
//  NutriScan
//
//  Created by albaraa alsayed on 17/02/1448 AH.
//

import Foundation

enum EmptyState {
    case noConnection, error404, noScans, noNotificationPermission, noNotifications, noSaved, noSearchResults
    
    var title: String {
        switch self {
        case .noConnection:
            return "No Internet Connection"
        case .error404:
            return "Error 404"
        case .noScans:
            return "No Scans yet"
        case .noNotificationPermission:
            return "Turn on notifications"
        case .noNotifications:
            return "No Notifications"
        case .noSaved:
            return "No Saved scans"
        case .noSearchResults:
            return "No results found"
        }
    }
    
    var description: String {
        switch self {
        case .noConnection:
            return "Oops! It seems you're currently offline."
        case .error404:
            return "Oops! The page you're looking for can't be found."
        case .noScans:
            return "Start your first scan to see whether a product is safe for you."
        case .noNotificationPermission:
            return "Enable notifications to receive scan updates, reminders, and important health alerts."
        case .noNotifications:
            return "No new notifications right now.\nWe'll let you know when something important needs your attention."
        case .noSaved:
            return "You have nothing on your list yet.\nIt's never too late to change it :)"
        case .noSearchResults:
            return "No results found. Please try again."
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
        }
    }
    
    var actionLabel: String {
        switch self {
        case .error404, .noConnection:
            return "Try again"
        case .noScans:
            return "noScansPlaceholder"
        case .noNotificationPermission:
            return "Go to settings"
        case .noNotifications:
            return "Go back"
        case .noSaved:
            return "Scan Now"
        case .noSearchResults:
            return "Go to Scan"
        }
    }
}
