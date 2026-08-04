//
//  Color+AccountRestorationSemantic.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 04/08/2026.
//

import SwiftUI

// MARK: - Account Restoration Semantic Colors
extension Color {
    struct AccountRestorationSemantic {
        // MARK: Header
        static let headerBackground = Color.Teal.teal800
        static let headerTitle = Color.Teal.teal200
        static let headerSubtitle = Color.white.opacity(0.8)
        
        // MARK: Content Icon
        static let iconCircleOuter = Color.Teal.teal1000.opacity(0.1)
        static let iconCircleMiddle = Color.Teal.teal1000.opacity(0.2)
        static let iconCircleInner = Color.Teal.teal1000
        static let iconForeground = Color.white

        // MARK: Text & Info Card
        static let titleText = Color(light: Color.black, dark: Color.white)
        static let instructionText = Color(light: Color.Gray.gray1000, dark: Color.Teal.teal500)
        static let cardBackground = Color.Teal.teal1000.opacity(0.05)
        static let daysRemainingText = Color.Red.red500
        static let linkText = Color(light: Color.Teal.teal1000, dark: Color.Teal.teal100)
    }
}
