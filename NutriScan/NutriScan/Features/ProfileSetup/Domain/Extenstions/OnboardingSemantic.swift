//
//  OnboardingSemantic.swift
//  NutriScan
//
//  Created by Osama Hosam on 18/07/2026.
//

import SwiftUI

extension Color {
    enum ProfileSetupSemantic {

        // Background
        static let background = Color(
            light: .white,
            dark: Color.Teal.teal1600
        )

        // Titles
        static let title = Color(
            light: Color.Gray.gray1600,
            dark: .white
        )

        static let accent = Color(
            light: Color.Teal.teal900,
            dark: Color.Teal.teal500
        )

        static let subtitle = Color(
            light: Color.Gray.gray800,
            dark: Color.Teal.teal400
        )

        // Step Indicator
        static let stepCurrent = Color(
            light: Color.Teal.teal900,
            dark: Color.Teal.teal500
        )

        static let stepRemaining = Color(
            light: Color.Gray.gray700,
            dark: Color.Teal.teal400
        )

        // Navigation
        static let backButtonBorder = Color(
            light: Color.Teal.teal700,
            dark: Color.Teal.teal500
        )

        static let backButtonIcon = Color(
            light: Color.Teal.teal900,
            dark: Color.Teal.teal500
        )

        // Inputs & Cards
        static let cardBackground = Color(
            light: .white,
            dark: Color.Teal.teal1400
        )

        static let selectedCard = Color(
            light: Color.Teal.teal500,
            dark: Color.Teal.teal500
        )

        static let unselectedCard = Color(
            light: Color.Gray.gray100,
            dark: Color.Teal.teal1500
        )

        static let primaryText = Color(
            light: Color.Gray.gray1600,
            dark: .white
        )

        static let secondaryText = Color(
            light: Color.Gray.gray700,
            dark: Color.Teal.teal400
        )

        // Controls
        static let ruler = Color(
            light: Color.Teal.teal300,
            dark: Color.Teal.teal800
        )

        static let rulerSelected = Color(
            light: Color.Teal.teal900,
            dark: Color.Teal.teal500
        )

        // Buttons
        static let primaryButton = Color(
            light: Color.Teal.teal900,
            dark: Color.Teal.teal800
        )

        static let primaryButtonText = Color(
            light: .white,
            dark: .white
        )
    }
}
