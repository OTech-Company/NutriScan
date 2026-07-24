//
//  Color+RAGSemantic.swift
//  NutriScan
//

import SwiftUI

extension Color {
    enum RAGSemantic {
        // Backgrounds
        static let chatBackground = Color(light: .white, dark: Color.Teal.teal1600)
        static let userBubble = Color(light: Color.Teal.teal700, dark: Color.Teal.teal1300)
        static let aiBubble = Color(light: Color.Teal.teal100, dark: Color.Teal.teal1500)
        static let inputBarBackground = Color(light: .white, dark: Color.Teal.teal1600)
        static let sourceCardBackground = Color(light: Color.Teal.teal100, dark: Color.Teal.teal1400)

        // Text
        static let userText = Color(light: .white, dark: Color.Teal.teal100)
        static let aiText = Color(light: Color.Teal.teal1600, dark: Color.Teal.teal100)
        static let headerTitle = Color(light: Color.Teal.teal1600, dark: Color.Teal.teal100)
        static let sourceFileName = Color(light: Color.Teal.teal800, dark: Color.Teal.teal400)
        static let sourceSnippet = Color(light: Color.Gray.gray700, dark: Color.Teal.teal400)
        static let sourceScore = Color(light: Color.Teal.teal700, dark: Color.Teal.teal500)
        static let placeholder = Color(light: Color.Gray.gray600, dark: Color.Teal.teal700)

        // Accents
        static let sendButton = Color(light: Color.Teal.teal1000, dark: Color.Teal.teal500)
        static let sendButtonDisabled = Color(light: Color.Gray.gray400, dark: Color.Teal.teal1300)
        static let inputBorder = Color(light: Color.Teal.teal400, dark: Color.Teal.teal1200)
        static let inputBackground = Color(light: Color.Teal.teal100, dark: Color.Teal.teal1400)
        static let errorText = Color(light: Color.Red.red500, dark: Color.Red.red500)
    }
}
