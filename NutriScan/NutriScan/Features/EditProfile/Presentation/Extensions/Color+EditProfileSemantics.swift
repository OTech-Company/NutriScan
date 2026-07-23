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
        static let editableSurface = Color(light: Color.Gray.gray100, dark: Color.Teal.teal1400)

        static let borderPrimary = Color(light: Color.Gray.gray300, dark: Color.Teal.teal1200)
        static let borderSecondary = Color(light: Color.Gray.gray500, dark: Color.Teal.teal1300)
        
        static let textSecondary = Color(light: Color.Gray.gray600, dark: Color.Teal.teal1200)
        static let textTertiary = Color(light: Color.Gray.gray700, dark: Color.Teal.teal1200)
        static let titlePrimary = Color(light: Color.Gray.gray1300, dark: Color.Teal.teal500)

        // Profile Header
        static let profileName = Color(light: Color.Teal.teal800, dark: Color.Teal.teal800)
        static let profileEmail = Color(light: Color.Gray.gray600, dark: Color.Teal.teal1300)
        static let avatarBorder = Color.Teal.teal1000 // static, both modes
        static let editBadgeBackground = Color.Teal.teal1000
        static let editBadgeIcon = Color.white

        // Section titles
        static let sectionTitle = titlePrimary

        // Back button
        static let backButtonBorder = Color(light: Color.Teal.teal700, dark: Color.Teal.teal1200)
        static let backButtonIcon = backButtonBorder
    }
}
