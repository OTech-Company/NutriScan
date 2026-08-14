//
//  BackButton.swift
//  NutriScan
//
//  Created by Osama Hosam on 18/07/2026.
//

import SwiftUI

// MARK: - BackButton Style
enum BackButtonStyle {
    case onWhite
    case onTeal
}

// MARK: - Back Button
struct BackButton: View {
    var action: () -> Void
    var style: BackButtonStyle = .onWhite

    private var backgroundColor: Color {
        switch style {
        case .onWhite: return Color.BackButtonSemantics.onWhiteBackground
        case .onTeal:  return Color.BackButtonSemantics.onTealBackground
        }
    }

    private var borderColor: Color {
        switch style {
        case .onWhite: return Color.BackButtonSemantics.onWhiteBorder
        case .onTeal:  return Color.BackButtonSemantics.onTealBorder
        }
    }

    private var iconColor: Color {
        switch style {
        case .onWhite: return Color.BackButtonSemantics.onWhiteIcon
        case .onTeal:  return Color.BackButtonSemantics.onTealIcon
        }
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(iconColor)
                .frame(width: 48, height: 48)
                .background(backgroundColor)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(borderColor, lineWidth: 1)
                )
        }
        .accessibilityLabel("Back")
        .accessibilityIdentifier("navigation.back")
    }
}
