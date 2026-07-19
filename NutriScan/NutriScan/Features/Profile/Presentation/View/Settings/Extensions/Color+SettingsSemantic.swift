//
//  Color+SettingsSemantic.swift
//  NutriScan
//

import SwiftUI

// MARK: - Settings Semantic Colors
extension Color {
    struct SettingsSemantic {

        // MARK: - Screen Background
        static let screenBackground = Color(
            light: .white,
            dark: Color.Teal.teal1600
        )

        // MARK: - Header
        static let headerBackground = Color.Teal.teal800
        static let headerTitle = Color(light: Color.Teal.teal300, dark: Color.Teal.teal200)
        static let headerSubtitle = Color(light: Color.Gray.gray100, dark: Color.Gray.gray200)
        static let backButtonBackground = Color(light: Color.white.opacity(0.08), dark: Color.white.opacity(0.12))
        static let backButtonBorder = Color(light: Color.white.opacity(0.5), dark: Color.white.opacity(0.4))
        static let backButtonIcon = Color.white

        // MARK: - Section Row
        static let rowBackground = Color(light: Color.Gray.gray100, dark: Color.Teal.teal1500)
        static let rowTitle = Color(light: Color.Gray.gray500, dark: Color.Teal.teal1200)
        static let rowChevron = Color(light: Color.Gray.gray500, dark: Color.Gray.gray500)
        static let rowIconTint = Color(light: Color.Teal.teal1000, dark: Color.Teal.teal1000)
        static let rowIconBackground = Color(light: Color.Teal.teal200, dark: Color.Teal.teal1600)
        static let rowShadow = Color(light: Color.black.opacity(0.05), dark: Color.black.opacity(0.2))

        // MARK: - Segment Picker (Appearance / Language)
        static let segmentBackground = Color(light: Color.Gray.gray300, dark: Color.Teal.teal1600)
        static let segmentSelectedBackground = Color(light: .white, dark: Color.Teal.teal700)
        static let segmentSelectedText = Color(light: Color.Gray.gray800, dark: .white)
        static let segmentUnselectedText = Color(light: Color.Gray.gray800, dark: Color.Teal.teal400)

        // MARK: - Logout Button
        static let logoutBorder = Color(light: Color.Red.red500.opacity(0.4), dark: Color.Red.red500.opacity(0.6))
        static let logoutTitle = Color.Red.red500
        static let logoutIcon = Color.Red.red500
        static let logoutRawBackground = Color(light: .white, dark: Color.Teal.teal1600)
        static let logoutIconBackground = Color(light: Color.Red.red100, dark: Color.Teal.teal1500)

    }
}
