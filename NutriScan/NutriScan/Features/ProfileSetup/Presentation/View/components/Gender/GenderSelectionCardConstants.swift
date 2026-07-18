//
//  GenderSelectionCardConstants.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 17/07/2026.
//
import Foundation
import SwiftUI

enum GenderSelectionCardConstants {
    // Unselected (Female-sized) card
    static let unselectedWidth: CGFloat = 136
    static let unselectedHeight: CGFloat = 148

    // Selected (Male-sized) card
    static let selectedWidth: CGFloat = 179
    static let selectedHeight: CGFloat = 180

    static let cornerRadius: CGFloat = 24
    static let internalSpacing: CGFloat = 4

    static let selectedPaddingTop: CGFloat = 69
    static let selectedPaddingBottom: CGFloat = 68
    static let selectedPaddingHorizontal: CGFloat = 32

    static let unselectedFontSize: CGFloat = 19
    static let selectedFontSize: CGFloat = 24

    static let imageSize: CGFloat = 104
    
    static let glowRadius: CGFloat = 30
    static let selectedScale: CGFloat = 1.03

    static let springAnimation: Animation = .spring(response: 0.35, dampingFraction: 0.8)
}
