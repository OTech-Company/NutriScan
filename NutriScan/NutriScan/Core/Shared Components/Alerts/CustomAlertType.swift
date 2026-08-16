//
//  CustomAlertType.swift
//  NutriScan
//
//  Created by albaraa alsayed on 23/07/2026.
//

import SwiftUI
import UIKit

enum CustomAlertType: CaseIterable, Hashable, Sendable {
    case warning
    case success
    case error
    case delete
    case noInternet
    
    var iconName: String {
        switch self {
        case .warning: return "icWarning"
        case .delete: return "trash"
        case .success: return "successFilled"
        case .error: return "errorIcon"
        case .noInternet: return "noWifiIcon"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .warning: return Color.Yellow.yellow500
        case .delete: return Color.Red.red500
        case .success: return Color.Teal.teal600
        case .error, .noInternet: return Color.Red.red500
        }
    }
    
    var hapticType: UINotificationFeedbackGenerator.FeedbackType {
        switch self {
        case .success: return .success
        case .warning, .delete: return .warning
        case .error, .noInternet: return .error
        }
    }
}
