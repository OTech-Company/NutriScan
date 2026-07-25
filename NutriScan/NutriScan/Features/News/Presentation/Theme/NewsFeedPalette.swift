//
//  NewsFeedPalette.swift
//  NewsFeed (Feature)
//
//  Semantic aliases built on top of the shared design tokens already in
//  the project (`Color.Teal`, `Color.Gray`, `Color.Red` from
//  Extensions/Colors+Extension.swift, and the `Color(light:dark:)`
//  initializer from Extensions/Color+Dynamic.swift).
//
//  NewsFeed views should reach for these semantic names, not the raw
//  step tokens directly — it keeps light/dark handling in one place and
//  makes re-theming the screen a one-file change.
//

import SwiftUI

enum NewsFeedPalette {
    // Backgrounds
    static let background = Color(light: Color.Gray.gray100, dark: Color.Gray.gray1600)
    static let surface = Color(light: .white, dark: Color.Gray.gray1500)
    static let surfaceMuted = Color(light: Color.Teal.teal100, dark: Color.Teal.teal1400.opacity(0.35))

    // Brand accent
    static let accent = Color.Teal.teal800
    static let accentStrong = Color.Teal.teal1300
    static let accentSoft = Color(light: Color.Teal.teal200, dark: Color.Teal.teal1400.opacity(0.4))

    // Text
    static let textPrimary = Color(light: Color.Gray.gray1600, dark: Color.Gray.gray100)
    static let textSecondary = Color(light: Color.Gray.gray800, dark: Color.Gray.gray500)
    static let textTertiary = Color(light: Color.Gray.gray600, dark: Color.Gray.gray700)
    static let divider = Color(light: Color.Gray.gray300, dark: Color.Gray.gray1400)

    // Status
    static let error = Color.Red.red500
    static let errorSoft = Color.Red.red100
}
