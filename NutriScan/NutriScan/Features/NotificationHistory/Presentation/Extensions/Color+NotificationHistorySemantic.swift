//
//  Color+NotificationHistorySemantic.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import SwiftUI

extension Color {
    struct NotificationHistorySemantic {
        // MARK: - Screen & Background
        static let screenBackground = Color(
            light: .white,
            dark: Color.Teal.teal1600
        )
        
        static let headerBackground = Color(
            light: Color.Teal.teal800,
            dark: Color.Teal.teal1000
        )

        // MARK: - Cards
        static let cardBackground = Color(
            light: Color.Gray.gray100,
            dark: Color.Teal.teal1500
        )
        
        static let unreadCardBackground = Color(
            light: Color.Teal.teal200.opacity(0.25),
            dark: Color.Teal.teal1400
        )
        
        static let cardBorder = Color(
            light: Color.Gray.gray300.opacity(0.5),
            dark: Color.Teal.teal1300.opacity(0.3)
        )

        // MARK: - Icon Container
        static let iconBadgeBackground = Color(
            light: .white,
            dark: .white
        )
        static let iconTint = Color.Teal.teal800
        
        // MARK: - Text Colors
        static let cardTitleText = Color(
            light: Color.Gray.gray900,
            dark: .white
        )
        static let cardBodyText = Color(
            light: Color.Gray.gray600,
            dark: Color.Teal.teal200.opacity(0.85)
        )
        static let timeText = Color(
            light: Color.Teal.teal700,
            dark: Color.Teal.teal300
        )
        static let headerTitleText = Color.white
        
        // MARK: - Badges & Dots
        static let unreadDot = Color(
            light: Color.Teal.teal700,
            dark: Color.Teal.teal400
        )
        static let clearAllButton = Color.Teal.teal200
    }
}
