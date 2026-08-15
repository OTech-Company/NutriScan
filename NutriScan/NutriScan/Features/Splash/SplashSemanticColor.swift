//
//  SplashSemanticColor.swift
//  NutriScan
//
//  Created by albaraa alsayed on 02/03/1448 AH.
//

import SwiftUI

enum SplashSemanticColor {
    static let backgroundInitial = Color(
        light: Color.Teal.teal1300,
        dark: Color.Teal.teal1400
    )
    static let backgroundFinal = Color(
        light: .white,
        dark: Color.Teal.teal1600
    )

    static let largeGlowInitialLeading = Color(
        light: Color.Teal.teal400,
        dark: Color.Teal.teal800.opacity(0.5)
    )
    static let largeGlowInitialTrailing = Color(
        light: Color.Teal.teal300,
        dark: Color.Teal.teal600.opacity(0.4)
    )
    static let largeGlowFinalLeading = Color(
        light: Color.Teal.teal1000,
        dark: Color.Teal.teal1400.opacity(0.55)
    )
    static let largeGlowFinalTrailing = Color(
        light: Color.Teal.teal700,
        dark: Color.Teal.teal1200.opacity(0.45)
    )

    static let smallGlowInitialLeading = Color(
        light: Color.Teal.teal300,
        dark: Color.Teal.teal700.opacity(0.42)
    )
    static let smallGlowInitialTrailing = Color(
        light: Color.Teal.teal100,
        dark: Color.Teal.teal500.opacity(0.3)
    )
    static let smallGlowFinalLeading = Color(
        light: Color.Teal.teal400,
        dark: Color.Teal.teal1500.opacity(0.5)
    )
    static let smallGlowFinalTrailing = Color(
        light: Color.Teal.teal200,
        dark: Color.Teal.teal1300.opacity(0.38)
    )

    static let logoInitial = Color(
        light: Color.Teal.teal100,
        dark: Color.Teal.teal100
    )
    static let logoFinal = Color(
        light: Color.Teal.teal1000,
        dark: Color.Teal.teal1000
    )
    static let logoShadow = Color(
        light: Color.Teal.teal1000.opacity(0.15),
        dark: Color.Teal.teal1000.opacity(0.15)
    )
}
