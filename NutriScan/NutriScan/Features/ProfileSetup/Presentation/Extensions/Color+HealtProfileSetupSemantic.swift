//
//  Color+HealtProfileSetupSemantic.swift
//  NutriScan
//
//  Created by youssef abdelfatah on 21/07/2026.
//
import SwiftUI

extension Color {
    enum HealthProfileSetupSemantic {
        // General Background
        static let background = Color(light: .white, dark: Color.Teal.teal1600)
        
        // Header Section
        static let title = Color(light: Color.Teal.teal1000, dark: .white)
        static let subtitle = Color(light: Color.Gray.gray700, dark: Color.Teal.teal400)
    }
}

#Preview {
    HealthProfileSetupView()
}
