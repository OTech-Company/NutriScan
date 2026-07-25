//
//  Color+ProfileSemantics.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import SwiftUI

extension Color {
    struct ProfileSemantics {
        static let background = Color(light: .white, dark: Color.Teal.teal1500)

        static let headerBackground = Color(light: Color.Teal.teal1000, dark: Color.Teal.teal1500)
        static let headerDecoration = Color(light: Color.Teal.teal1200, dark: Color.Teal.teal1400)

        static let containerBackground = Color(light: .white, dark: Color.Teal.teal1600)

        static let sectionTitle = Color.Teal.teal1000 // static both modes per spec

        static let userName = Color.white // static both modes

        static let streakBackground = Color.Teal.teal1200 // static both modes
        static let streakText = Color(light: .white, dark: Color.Teal.teal400)

        static let avatarBorder = Color.Teal.teal1400 // static both modes

        static let editIcon = Color(light: .white, dark: Color.Teal.teal300)

        static let dashedBorder = Color(light: Color.Teal.teal500, dark: Color.Teal.teal500)

        static let addMemberBackground = Color(light: Color.Teal.teal100, dark: Color.Teal.teal1600)
        static let addMemberText = Color(light: Color.Teal.teal1600, dark: Color.Teal.teal100)
        static let addMemberIcon = Color(light: Color.Teal.teal1000, dark: Color.Teal.teal100)
        static let addMemberIconBackground = Color(light: .white, dark: Color.Teal.teal100)
        static let addMemberIconStroke = Color.Teal.teal1000 // static both modes

        static let memberCardBackground = Color(light: Color.Teal.teal100, dark: Color.Teal.teal1600)
        static let memberCardBorder = Color.Teal.teal1000 // "Primary Teal Border" both modes
        static let memberName = Color(light: Color.Teal.teal1000, dark: Color.Teal.teal1000)
    }
}
