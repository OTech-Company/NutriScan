//
//  Color+ForgotPasswordSemantic.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 17/07/2026.
//

import SwiftUI

// MARK: - Forgot Password Semantic Colors
extension Color {
    struct ForgotPasswordSemantic {
        // Header
        static let headerTitle = Color(light: Color.Teal.teal300, dark: Color.Teal.teal300)
        static let headerSubtitle = Color(light: Color.Gray.gray100, dark: Color.Gray.gray100)
        
        // Options
        static let optionBackground = Color(light: .white, dark: Color.Teal.teal1400)
        static let optionSelectedBackground = Color(light: Color.Teal.teal100, dark: Color.Teal.teal1500)
        static let optionBorder = Color(light: Color.Teal.teal400.opacity(0.1), dark: Color.Teal.teal1300)
        static let optionSelectedBorder = Color(light: Color.Teal.teal600, dark: Color.Teal.teal400)
        
        // Option Icon Container
        static let iconContainerBackground = Color(light: Color.Teal.teal100, dark: Color.Teal.teal1300.opacity(0.6))
        static let iconContainerSelectedBackground = Color(light: Color.Teal.teal400, dark: Color.Teal.teal600)
        
        // Option Icon
        static let iconColor = Color(light: Color.Gray.gray1000, dark: Color.Teal.teal400)
        static let iconSelectedColor = Color(light: Color.Teal.teal1000, dark: Color.white)
        
        // Option Title
        static let optionTitleColor = Color(light: Color.Teal.teal1000, dark: Color.Teal.teal100)
        static let optionTitleSelectedColor = Color(light: Color.Teal.teal1000, dark: Color.Teal.teal400)
        
        // Option Subtitle
        static let optionSubtitleColor = Color(light: Color.Gray.gray1000, dark: Color.Teal.teal400)
        static let optionSubtitleSelectedColor = Color(light: Color.Gray.gray1000, dark: Color.Teal.teal300)
        
        // Arrow
        static let arrowColor = Color(light: Color.Gray.gray1000, dark: Color.Teal.teal1300)
        static let arrowSelectedColor = Color(light: Color.Teal.teal1000, dark: Color.Teal.teal400)
    }
}
