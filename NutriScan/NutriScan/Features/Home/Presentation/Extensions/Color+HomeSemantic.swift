//
//  Color+HomeSemantic.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 17/07/2026.
//

import SwiftUI

// MARK: - Home Feature Semantic Colors
extension Color {
    enum HomeSemantic {
        // General Background
        static let homeBackground = Color(light: .white, dark: Color.Teal.teal1600)
        
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
        static let scanSubtitle = Color(light: Color.Teal.teal700, dark: Color.Teal.teal400)
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
