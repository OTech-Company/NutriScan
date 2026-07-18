//
//  Color+LoginSemantic.swift
//  NutriScan
//

import SwiftUI

// MARK: - Login Semantic Colors
extension Color {
    struct LoginSemantic {

        // MARK: Header
        static let headerBackground = Color.Teal.teal800
        static let headerTitle = Color.Teal.teal200

        // MARK: Forgot Password Link
        static let forgotPasswordText = Color.Teal.teal1000

        // MARK: Divider ("OR")
        static let dividerLine = Color.Gray.gray800
        static let dividerLabel = Color(light: Color.Teal.teal1600, dark: Color.Teal.teal500)

        // MARK: Social Login Button
        static let socialButtonIcon = Color(light: Color.Teal.teal1600, dark: Color.Teal.teal400)
        static let socialButtonBorder = Color(light: Color.Gray.gray500, dark: Color.Teal.teal600)

        // MARK: Footer ("Don't have an account?")
        static let footerText = Color.Gray.gray1000
        static let footerLink = Color.Teal.teal1000
    }
}
