//
//  CustomAlertType.swift
//  NutriScan
//
//  Created by albaraa alsayed on 23/07/2026.
//

import SwiftUI
import UIKit

enum CustomAlertType {
    case warning
    case success
    case error
    case delete
    case internet
    
    var iconName: String {
        switch self {
        case .warning, .delete: return "icWarning"
        case .success: return "successFilled"
        case .error: return "errorIcon"
        case .internet: return "noWifiIcon"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .warning, .delete: return Color.Yellow.yellow500
        case .success: return Color.Teal.teal600
        case .error, .internet: return Color.Red.red500
        }
    }
    
    var hapticType: UINotificationFeedbackGenerator.FeedbackType {
        switch self {
        case .success: return .success
        case .warning, .delete: return .warning
        case .error, .internet: return .error
        }
    }
}
