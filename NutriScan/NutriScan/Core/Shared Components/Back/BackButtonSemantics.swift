//
//  BackButtonSemantics.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 19/07/2026.
//
import SwiftUI

extension Color {
    struct BackButtonSemantics {
        // MARK: - .onWhite variant
        // Icon & Border: teal1000 in both light and dark
        static let onWhiteBackground = Color(
            light: .white,
            dark: Color.Teal.teal1600
        )
        static let onWhiteBorder = Color.Teal.teal1000
        static let onWhiteIcon   = Color.Teal.teal1000

        // MARK: - .onTeal variant
        // Icon & Border: white in both light and dark
        static let onTealBackground = Color.white
        static let onTealBorder     = Color.white
        static let onTealIcon       = Color.white
    }
}
