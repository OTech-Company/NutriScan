//
//  Color+VerificationPendingSemantic.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 20/07/2026.
//

import SwiftUI

// MARK: - Verification Pending Semantic Colors
extension Color {
    struct VerificationPendingSemantic {
        // MARK: Header
        static let headerBackground = Color.Teal.teal800
        static let headerTitle = Color.Teal.teal200
        static let headerSubtitle = Color.white.opacity(0.8)
        
        static let backButtonBackground = Color.white.opacity(0.08)
        static let backButtonBorder = Color.white.opacity(0.5)
        static let backButtonIcon = Color.white

        // MARK: Content Icon
        static let iconCircleOuter = Color.Teal.teal1000.opacity(0.1)
        static let iconCircleMiddle = Color.Teal.teal1000.opacity(0.2)
        static let iconCircleInner = Color.Teal.teal1000
        static let iconForeground = Color.white

        // MARK: Text & Links
        static let emailText = Color(light: Color.black, dark: Color.white)
        static let instructionText = Color(light: Color.Gray.gray1000, dark: Color.Teal.teal500)
        static let linkText = Color(light: Color.Teal.teal1000, dark: Color.Teal.teal100)
        static let timerText = Color(light: Color.Teal.teal1000, dark: Color.Teal.teal100)
    }
}
