//
//  Color+ToastSemantic.swift
//  NutriScan
//

import SwiftUI

// MARK: - Toast Semantic Colors
extension Color {
    
    struct ToastSemantic {

        // MARK: Container
        static let background = Color(light: .white, dark: Color.Gray.gray1600)
        static let border = Color(light: Color.Gray.gray300, dark: Color.Gray.gray1400)
        static let message = Color(light: Color.Gray.gray1500, dark: .white)

        // MARK: Close Button
        static let closeIcon = Color(light: Color.Gray.gray800, dark: Color.Gray.gray500)
        static let closeBackground = Color(light: Color.Gray.gray200, dark: Color.Gray.gray1400)

        // MARK: Success
        static let successTheme = Color(light: Color.Teal.teal1000, dark: Color.Teal.teal500)
        static let successBadge = Color(light: Color.Teal.teal100, dark: Color.Teal.teal1600.opacity(0.6))

        // MARK: Error
        static let errorTheme = Color(light: Color.Red.red500, dark: Color.Red.red500)
        static let errorBadge = Color(light: Color.Red.red100, dark: Color.Red.red100.opacity(0.15))

        // MARK: Info
        static let infoTheme = Color(light: .blue, dark: Color.blue.opacity(0.8))
        static let infoBadge = Color(light: Color.blue.opacity(0.1), dark: Color.blue.opacity(0.2))

        // MARK: Warning
        static let warningTheme = Color(light: .orange, dark: Color.orange.opacity(0.8))
        static let warningBadge = Color(light: Color.orange.opacity(0.1), dark: Color.orange.opacity(0.2))
    }
}
