//
//  Colors.swift
//  NutriScan
//
//  Created by Osama Hosam on 13/07/2026.
//

import SwiftUI

extension Color {
    
    struct Gray {
        static let gray100 = Color(red: 248 / 255.0, green: 248 / 255.0, blue: 249 / 255.0)
        static let gray200 = Color(red: 241 / 255.0, green: 241 / 255.0, blue: 241 / 255.0)
        static let gray300 = Color(red: 229 / 255.0, green: 229 / 255.0, blue: 228 / 255.0)
        static let gray400 = Color(red: 214 / 255.0, green: 214 / 255.0, blue: 213 / 255.0)
        static let gray500 = Color(red: 192 / 255.0, green: 192 / 255.0, blue: 192 / 255.0)
        static let gray600 = Color(red: 166 / 255.0, green: 165 / 255.0, blue: 165 / 255.0)
        static let gray700 = Color(red: 137 / 255.0, green: 137 / 255.0, blue: 137 / 255.0)
        static let gray800 = Color(red: 119 / 255.0, green: 119 / 255.0, blue: 119 / 255.0)
        static let gray900 = Color(red: 113 / 255.0, green: 113 / 255.0, blue: 113 / 255.0)
        static let gray1000 = Color(red: 106 / 255.0, green: 106 / 255.0, blue: 106 / 255.0)
        static let gray1200 = Color(red: 95 / 255.0, green: 95 / 255.0, blue: 95 / 255.0)
        static let gray1300 = Color(red: 84 / 255.0, green: 84 / 255.0, blue: 84 / 255.0)
        static let gray1400 = Color(red: 62 / 255.0, green: 62 / 255.0, blue: 62 / 255.0)
        static let gray1500 = Color(red: 83 / 255.0, green: 80 / 255.0, blue: 81 / 255.0)
        static let gray1600 = Color(red: 57 / 255.0, green: 60 / 255.0, blue: 60 / 255.0)
    }
    
    struct Teal {
        static let teal100 = Color(red: 232 / 255.0, green: 250 / 255.0, blue: 250 / 255.0)
        static let teal200 = Color(red: 212 / 255.0, green: 241 / 255.0, blue: 242 / 255.0)
        static let teal300 = Color(red: 202 / 255.0, green: 242 / 255.0, blue: 244 / 255.0)
        static let teal400 = Color(red: 163 / 255.0, green: 233 / 255.0, blue: 236 / 255.0)
        static let teal500 = Color(red: 117 / 255.0, green: 222 / 255.0, blue: 227 / 255.0)
        static let teal600 = Color(red: 71 / 255.0, green: 211 / 255.0, blue: 217 / 255.0)
        static let teal700 = Color(red: 47 / 255.0, green: 197 / 255.0, blue: 204 / 255.0)
        static let teal800 = Color(red: 23 / 255.0, green: 184 / 255.0, blue: 190 / 255.0)
        static let teal900 = Color(red: 21 / 255.0, green: 174 / 255.0, blue: 180 / 255.0)
        static let teal1000 = Color(red: 19 / 255.0, green: 164 / 255.0, blue: 171 / 255.0)
        static let teal1200 = Color(red: 17 / 255.0, green: 147 / 255.0, blue: 154 / 255.0)
        static let teal1300 = Color(red: 16 / 255.0, green: 129 / 255.0, blue: 136 / 255.0)
        static let teal1400 = Color(red: 11 / 255.0, green: 95 / 255.0, blue: 101 / 255.0)
        static let teal1500 = Color(red: 10 / 255.0, green: 84 / 255.0, blue: 90 / 255.0)
        static let teal1600 = Color(red: 15 / 255.0, green: 71 / 255.0, blue: 74 / 255.0)
    }
    
    struct Red {
        static let red100 = Color(red: 255 / 255.0, green: 241 / 255.0, blue: 243 / 255.0)
        static let red500 = Color(red: 250 / 255.0, green: 77 / 255.0, blue: 94 / 255.0) 
    }
}

// MARK: - Home Feature Semantic Colors
extension Color {
    enum HomeSemantic {
        // General Background
        static let homeBackground = Color(light: Color.Teal.teal100, dark: Color.Teal.teal1600)
        
        // Greeting Section
        static let greetingTitle = Color(light: Color.Teal.teal1000, dark: Color.Teal.teal400)
        static let greetingSubtitle = Color(light: Color.Teal.teal1600, dark: Color.Teal.teal400)
        static let greetingBell = Color(light: Color.Teal.teal1600, dark: Color.Teal.teal400)
        
        // Daily Health Tip Section
        static let tipIconBackground = Color(light: Color.Teal.teal200, dark: Color.Teal.teal1300)
        static let tipIcon = Color(light: Color.Teal.teal800, dark: Color.Teal.teal400)
        static let tipLabel = Color(light: Color.Teal.teal800, dark: Color.Teal.teal400)
        static let tipMessage = Color(light: Color.Teal.teal1600, dark: Color.Teal.teal200)
        static let tipBorder = Color(light: Color.Teal.teal400, dark: Color.Teal.teal800)
        static let tipBackgroundStart = Color(light: Color.Teal.teal100, dark: Color.Teal.teal1400)
        static let tipBackgroundEnd = Color(light: Color.Teal.teal200, dark: Color.Teal.teal1500)
        
        // Ready To Scan Section
        static let scanCardBackground = Color(light: .white, dark: Color.Teal.teal1400)
        static let scanTitle = Color(light: Color.Teal.teal1400, dark: Color.Teal.teal100)
        static let scanSubtitle = Color(light: Color(red: 96 / 255, green: 166 / 255, blue: 161 / 255), dark: Color.Teal.teal400)
        static let scanIcon = Color(light: Color.Teal.teal800, dark: Color.Teal.teal400)
        static let scanBorder = Color(light: Color.Teal.teal500, dark: Color.Teal.teal800)
        
        // Recent History Section
        static let historyCardBackground = Color(light: .white, dark: Color.Teal.teal1400)
        static let historyTitle = Color(light: Color.Teal.teal1600, dark: Color.Teal.teal100)
        static let historySubtitle = Color(light: Color.Gray.gray700, dark: Color.Teal.teal400)
        static let historyHeaderTitle = Color(light: Color.Teal.teal1600, dark: Color.Teal.teal100)
        static let historyHeaderAction = Color(light: Color.Teal.teal1400, dark: Color.Teal.teal400)
        
        // Tags
        static let tagSafeBackground = Color(light: Color.Teal.teal200, dark: Color.Teal.teal1300)
        static let tagSafeText = Color(light: Color.Teal.teal800, dark: Color.Teal.teal400)
    }
}

// MARK: - Light/Dark Dynamic Color Initializer
extension Color {
    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}

extension Color {
    enum ProfileSetupSemantic {
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
