//
//  ChipSemantics.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 19/07/2026.
//

import SwiftUI

extension Color {
    struct ChipSemantics {
        static let defaultBackground = Color(
            light: .white, dark: Color.Teal.teal1400)
        static let defaultBorder = Color(
            light: Color.Gray.gray500, dark: Color.Teal.teal1300)
        static let defaultText = Color(
            light: Color.Gray.gray1400, dark: Color.Teal.teal700)

        static let selectedBackground = Color(
            light: Color.Gray.gray500, dark: Color.Teal.teal1000)
        static let selectedBorder = Color(
            light: Color.Gray.gray700, dark: Color.Teal.teal500)
        static let selectedText = Color(
            light: Color.Gray.gray1400, dark: Color.Teal.teal1600)

        static let addBorder = Color(
            light: Color.Gray.gray400, dark: Color.Teal.teal1300)
        static let addText = Color(
            light: Color.Gray.gray700, dark: Color.Teal.teal1200)
    }
}
