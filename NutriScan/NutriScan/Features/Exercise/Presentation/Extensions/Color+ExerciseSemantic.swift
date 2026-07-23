//
//  Color+ExerciseSemantic.swift
//  NutriScan
//

import SwiftUI

// MARK: - Exercise Feature Semantic Colors
extension Color {
    enum ExerciseSemantic {

        // MARK: Screen Background
        static let screenBackground  = Color(light: .white, dark: Color.Teal.teal1600)

        // MARK: Search Bar
        static let searchBackground  = Color(light: .white,              dark: Color.Teal.teal1600)
        static let searchBorder      = Color(light: Color.Gray.gray300,  dark: Color.Teal.teal1200)
        static let searchIcon        = Color(light: Color.Teal.teal800,  dark: Color.Teal.teal400)
        static let searchText        = Color(light: Color.Gray.gray1400, dark: Color.Teal.teal200)
        static let searchPlaceholder = Color(light: Color.Gray.gray600,  dark: Color.Teal.teal1200)
        static let searchButtonBg    = Color(light: Color.Teal.teal1000, dark: Color.Teal.teal800)

        // MARK: Category Chip
        static let categoryChipBg                = Color(light: .white,              dark: Color.Teal.teal1600)
        static let categoryChipBorderSelected    = Color(light: Color.Teal.teal1000, dark: Color.Teal.teal1000)
        static let categoryChipTextSelected      = Color(light: Color.Teal.teal1000, dark: Color.Teal.teal1000)
        static let categoryChipBorderUnselected  = Color(light: Color.Gray.gray400,  dark: Color.Teal.teal1400)
        static let categoryChipTextUnselected    = Color(light: Color.Gray.gray700,  dark: Color.Teal.teal1400)

        // MARK: Exercise Row Card
        static let cardBackground    = Color(light: Color.Teal.teal100,  dark: Color.Teal.teal1400)
        static let rowTitle          = Color(light: Color.Teal.teal1600, dark: Color.Teal.teal400)
        static let rowSubtitle       = Color(light: Color.Gray.gray700,  dark: Color.Teal.teal1200)
        static let rowChevron        = Color(light: Color.Teal.teal800,  dark: Color.Teal.teal1000)

        // MARK: Bottom Sheet
        static let sheetBackground   = Color(light: .white,              dark: Color.Teal.teal1500)
        static let sheetHandle       = Color(light: Color.Gray.gray300,  dark: Color.Teal.teal1300)
        static let sheetTitle        = Color(light: Color.Teal.teal1600, dark: Color.Teal.teal400)
        static let sheetSubtitle     = Color(light: Color.Gray.gray700,  dark: Color.Teal.teal1200)
        static let instructionHead   = Color(light: Color.Gray.gray1600, dark: Color.Teal.teal1000)
        static let instructionText   = Color(light: Color.Gray.gray600,  dark: Color.Teal.teal1200)
        static let readMoreText      = Color(light: Color.Teal.teal500,  dark: Color.Teal.teal400)
        static let ctaBackground     = Color(light: Color.Teal.teal800,  dark: Color.Teal.teal700)
        static let ctaText: Color    = .white
    }
}
