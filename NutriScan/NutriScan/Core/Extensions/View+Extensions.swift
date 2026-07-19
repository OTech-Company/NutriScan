//
//  View+Extensions.swift
//  NutriScan
//
//  Created by albaraa alsayed on 29/01/1448 AH.
//

import SwiftUI

extension View {
    func customTealShadow() -> some View {
        self.shadow(color: Color.Teal.teal1000.opacity(0.4), radius: 15, x: 0, y: 10)
    }

    func dailyTipShadow() -> some View {
        self.shadow(
            color: Color(red: 26 / 255, green: 177 / 255, blue: 177 / 255).opacity(0.05),
            radius: 10,
            x: 0,
            y: 10
        )
    }
}
