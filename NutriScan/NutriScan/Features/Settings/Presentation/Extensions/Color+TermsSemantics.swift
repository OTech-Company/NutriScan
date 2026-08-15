//
//  Color+TermsSemantics.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import SwiftUI

extension Color {
    struct TermsSemantic {
        static let background = Color.SettingsSemantic.screenBackground
        static let title = Color(
            light: Color.Gray.gray500,
            dark: Color.Teal.teal200
        )
        static let body = Color(
            light: Color.Gray.gray700,
            dark: Color.Teal.teal100
        )
        static let cardBackground = Color.SettingsSemantic.rowBackground
    }
}
