//
//  Color+NotificationSemantic.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import SwiftUI

extension Color {
    struct NotificationSemantic {
        // MARK: - Screen Background
        static let screenBackground = Color(
            light: .white,
            dark: Color.Teal.teal1600
        )
        
        // MARK: - Cards
        static let cardBackground = Color(
            light: Color.Gray.gray100,
            dark: Color.Teal.teal1500
        )
        
        // MARK: - Texts
        static let titleText = Color(
            light: Color.Gray.gray500,
            dark: Color.Teal.teal300
        )
        static let sectionLabel = Color(
            light: Color.Gray.gray500,
            dark: Color.Teal.teal500
        )
        static let quietHoursTimeText = Color(
            light: Color.Gray.gray600,
            dark: .white
        )
        
        // MARK: - Icons & Controls
        static let iconTint = Color(
            light: Color.Teal.teal800,
            dark: Color.Teal.teal400
        )
        static let iconBackground = Color(
            light: Color.Teal.teal200,
            dark: Color.Teal.teal1600
        )
        static let toggleTint = Color(
            light: Color.Teal.teal700,
            dark: Color.Teal.teal500
        )
    }
}
