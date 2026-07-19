//
//  Color+OnboardingSemantic.swift
//  NutriScan
//

import SwiftUI

// MARK: - Onboarding Semantic Colors
extension Color {
    struct OnboardingSemantic {

        // MARK: Background
        static let background = Color(light: .white, dark: Color.Teal.teal1600)

        // MARK: Navigation Buttons (BACK / SKIP)
        static let navButtonForeground = Color(light: Color.Gray.gray700, dark: Color.Teal.teal400)

        // MARK: Page Title
        static let pageTitle = Color(light: .primary, dark: Color.Teal.teal100)

        // MARK: Page Description
        static let pageDescription = Color(light: .secondary, dark: Color.Teal.teal400)

        // MARK: Page Indicator Dots
        static let dotSelected = Color(light: Color.Gray.gray700, dark: Color.Teal.teal700)
        static let dotUnselected = Color(light: Color.Gray.gray400, dark: Color.Teal.teal1300)
    }
}
