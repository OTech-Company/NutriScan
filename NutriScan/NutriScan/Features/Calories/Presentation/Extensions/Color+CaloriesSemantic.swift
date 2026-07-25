//
//  Color+CaloriesSemantic.swift
//  NutriScan
//
//  Created by albaraa alsayed on 22/07/2026.
//

import SwiftUI

// MARK: - Calories Feature Semantic Colors
extension Color {
    enum CaloriesSemantic {
        // MARK: General
        static let background = Color(light: .white, dark: Color.Teal.teal1600)
        static let cardBackground = Color(light: .white, dark: Color.Teal.teal1400)
        
        // MARK: Daily Products Section
        static let dailyProductsTitle = Color(light: Color.Teal.teal1200, dark: Color.Teal.teal1000)
        static let dailyProductsBadgeBackground = Color.Teal.teal1000
        static let dailyProductsBadgeText = Color.Teal.teal300
        static let dailyProductsKcalLabel = Color.Teal.teal1000
        static let dailyProductsCardBorder = Color(light: Color.Gray.gray600, dark: Color.Teal.teal1200)
        static let dailyProductsAddFoodText = Color(light: Color.Teal.teal1400, dark: Color.Teal.teal700)
        
        // MARK: Calorie Goals Section
        static let goalsBackground = Color.Teal.teal500
        static let goalsTitle = Color.Teal.teal100
        static let goalsLabelText = Color.Teal.teal1600
        static let goalsValueText = Color.Teal.teal1300
        static let goalsValueBackground = Color.Teal.teal300
        static let goalsProgressTrack = Color.Teal.teal300
        static let goalsProgressFill = Color.Teal.teal1000
        
        // MARK: Steps Gauge Card
        static let stepsNumber = Color(light: Color.Gray.gray1600, dark: Color.Teal.teal200)
        static let stepsLabel = Color(light: Color.Gray.gray700, dark: Color.Teal.teal200)
        
        // MARK: Exercise Card
        static let exerciseIconBackground = Color.Teal.teal200
        static let exerciseTitle = Color(light: Color.Teal.teal1000, dark: Color.Teal.teal1000)
        static let exerciseKcalValue = Color(light: Color.Teal.teal1000, dark: Color.Teal.teal400)
        static let exerciseSubtitle = Color(light: Color.Teal.teal1600, dark: Color.Teal.teal1200)
        
        // MARK: Water Section
        static let waterTitle = Color(light: Color.Gray.gray1600, dark: Color.Teal.teal300)
        static let waterCount = Color.Teal.teal1000
        static let waterFilledCup = Color.Teal.teal700
        static let waterEmptyCup = Color(light: Color.Gray.gray400, dark: Color.Teal.teal1300)
        
        // MARK: Add Button (shared)
        static let addButtonIcon = Color(light: Color.Gray.gray1000, dark: Color.Teal.teal1000)
        static let addButtonBackground = Color(light: Color.Gray.gray200, dark: Color.Teal.teal1600)
        static let addButtonLargeBackground = Color(light: Color.Teal.teal100, dark: Color.Teal.teal1600)
        
        // MARK: History Bar Chart
        static let chartCardBackground = Color(light: .white, dark: Color.Teal.teal1400)
        static let axisText = Color(light: Color.Gray.gray800, dark: Color.Gray.gray600)
        static let chartTitle = Color(light: Color.Gray.gray1400, dark: .white)
    }
}
