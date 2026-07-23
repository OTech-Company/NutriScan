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
            light: Color.Teal.teal1000,
            dark: Color.Teal.teal1000
        )

        static let subtitle = Color(
            light: Color.Gray.gray700,
            dark: Color.Teal.teal1300
        )

        // Step Indicator
        static let stepCurrent = Color(
            light: Color.Teal.teal1000,
            dark: Color.Teal.teal1000
        )

        static let stepRemaining = Color(
            light: Color.Gray.gray600,
            dark: Color.Teal.teal300 
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

        static let primaryText = Color.Teal.teal1600

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
        // Gender Screen
        // Female Card (Unselected)
        static let femaleCardBackground = Color(light: Color.Red.red100, dark: Color.Teal.teal1400)
        static let femaleCardText = Color(light: Color.Red.red500, dark: Color.Red.red100)

        // Male Card (Selected)
        static let maleCardBackground = Color.Teal.teal500
        static let maleCardText = Color.Teal.teal1600 // static, both modes

        // Selection indicator (triangle above selected card)
        static let selectionIndicator = Color(light: Color.Teal.teal800, dark: Color.Teal.teal500)
        
        static let whatIsYourText = Color(
            light: Color.Gray.gray1600,
            dark: Color.Teal.teal100
        )
    }
}
