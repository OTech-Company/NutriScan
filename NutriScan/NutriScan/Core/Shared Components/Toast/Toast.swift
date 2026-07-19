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
            case .success: return .green
            case .error: return .red
            case .info: return .blue
            case .warning: return .orange
            }
        }
    }
}
