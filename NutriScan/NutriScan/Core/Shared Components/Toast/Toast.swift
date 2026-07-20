//
//  Toast.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 20/07/2026.
//

import SwiftUI

struct Toast: Equatable, Identifiable {
    let id = UUID()
    let style: Style
    let message: String

    enum Style: Equatable {
        case success
        case error
        case info
        case warning

        var iconName: String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .error: return "xmark.circle.fill"
            case .info: return "info.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            }
        }

        var themeColor: Color {
            switch self {
            case .success: return Color.ToastSemantic.successTheme
            case .error:   return Color.ToastSemantic.errorTheme
            case .info:    return Color.ToastSemantic.infoTheme
            case .warning: return Color.ToastSemantic.warningTheme
            }
        }

        var badgeColor: Color {
            switch self {
            case .success: return Color.ToastSemantic.successBadge
            case .error:   return Color.ToastSemantic.errorBadge
            case .info:    return Color.ToastSemantic.infoBadge
            case .warning: return Color.ToastSemantic.warningBadge
            }
        }
    }
}
