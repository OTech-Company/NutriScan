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
    func customAlertShadow() -> some View {
        self.shadow(color: Color.Teal.teal1000, radius: 100, x: 0, y: 10)
    }
    func customLightShadow() -> some View {
        self.shadow(color: Color.Teal.teal1000.opacity(0.2), radius: 20, x: 0, y: 10)
    }
}
