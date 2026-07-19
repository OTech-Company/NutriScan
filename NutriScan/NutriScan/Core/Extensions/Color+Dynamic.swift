//
//  Color+Dynamic.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 17/07/2026.
//

import SwiftUI

// MARK: - Light/Dark Dynamic Color Initializer
extension Color {
    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}
