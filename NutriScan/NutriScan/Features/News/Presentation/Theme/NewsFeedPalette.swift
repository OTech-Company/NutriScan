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
    static let background = Color(light: .white, dark: Color.Teal.teal1600)
    static let cardBackground = Color(light: .white, dark: Color.Teal.teal1400)
    static let skeleton = Color(light: Color.Gray.gray300, dark: Color.Teal.teal1400)
    static let imagePlaceholderBackground = Color(light: Color.Gray.gray200, dark: Color.Teal.teal1500)
    static let imagePlaceholderForeground = Color(light: Color.Gray.gray500, dark: Color.Teal.teal900)

    static let accent = Color.Teal.teal1000
    static let textPrimary = Color(light: Color.Gray.gray1600, dark: Color.Teal.teal300)
    static let textSecondary = Color(light: Color.Gray.gray600, dark: Color.Teal.teal1200)
    static let metadataAccent = Color.Teal.teal600
    static let metadataSecondary = Color(light: Color.Gray.gray600, dark: Color.Teal.teal1200)
    static let menuIcon = Color(light: Color.Gray.gray1400, dark: Color.Teal.teal400)

    static let chipBackground = Color.clear
    static let chipSelectedText = Color.Teal.teal1000
    static let chipText = Color(light: Color.Gray.gray700, dark: Color.Teal.teal1200)
    static let chipSelectedBorder = Color.Teal.teal1000
    static let chipBorder = Color(light: Color.Gray.gray400, dark: Color.Teal.teal1400)

    static let cardShadow = Color.Teal.teal1000.opacity(0.2)

    // Article detail aliases retained for the existing sheet.
    static let surface = cardBackground
    static let surfaceMuted = skeleton
    static let accentSoft = Color(light: Color.Teal.teal200, dark: Color.Teal.teal1400)
    static let textTertiary = metadataSecondary
    static let divider = Color(light: Color.Gray.gray300, dark: Color.Teal.teal1400)
}
