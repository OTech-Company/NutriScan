//
//  Color+EditProfileSemantics.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 19/07/2026.
//

import SwiftUI

extension Color {
    struct EditProfileSemantics {
        static let backgroundPrimary = Color(light: .white, dark: Color.Teal.teal1400)
        static let surfacePrimary = Color(light: .white, dark: Color.Teal.teal1400)

        static let borderPrimary = Color(light: Color.Gray.gray300, dark: Color.Teal.teal1200)
        static let borderSecondary = Color(light: Color.Gray.gray500, dark: Color.Teal.teal1300)

        static let textPrimary = Color(light: Color.Gray.gray1400, dark: Color.Teal.teal700)
        static let textSecondary = Color(light: Color.Gray.gray600, dark: Color.Teal.teal1300)
        static let textTertiary = Color(light: Color.Gray.gray700, dark: Color.Teal.teal1200)
        static let titlePrimary = Color(light: Color.Gray.gray1300, dark: Color.Teal.teal500)

        // Chips
        static let chipDefaultBackground = Color(light: .white, dark: Color.Teal.teal1400)
        static let chipDefaultBorder = Color(light: Color.Gray.gray500, dark: Color.Teal.teal1300)
        static let chipDefaultText = Color(light: Color.Gray.gray1400, dark: Color.Teal.teal700)

        static let chipSelectedBackground = Color(light: Color.Gray.gray500, dark: Color.Teal.teal1000)
        static let chipSelectedBorder = Color(light: Color.Gray.gray700, dark: Color.Teal.teal500)
        static let chipSelectedText = Color(light: Color.Gray.gray1400, dark: Color.Teal.teal1600)

        static let chipAddBorder = Color(light: Color.Gray.gray400, dark: Color.Teal.teal1300)
        static let chipAddText = Color(light: Color.Gray.gray700, dark: Color.Teal.teal1200)

        // Profile Header
        static let profileName = Color(light: Color.Teal.teal800, dark: Color.Teal.teal700)
        static let profileEmail = Color(light: Color.Gray.gray600, dark: Color.Teal.teal1300)
        static let avatarBorder = Color.Teal.teal700 // static, both modes
        static let editBadgeBackground = Color.Teal.teal700
        static let editBadgeIcon = Color.white

        // Buttons
        static let primaryButtonShadow = Color(
            light: Color.Teal.teal800.opacity(0.25),
            dark: Color.Teal.teal800.opacity(0.25)
        )

        // Section titles
        static let sectionTitle = titlePrimary

        // Back button
        static let backButtonBorder = Color(light: Color.Teal.teal700, dark: Color.Teal.teal1200)
        static let backButtonIcon = backButtonBorder
    }
}
