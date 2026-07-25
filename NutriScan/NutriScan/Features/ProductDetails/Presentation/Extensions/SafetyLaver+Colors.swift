//
//  SafetyLaver+Colors.swift
//  NutriScan
//
//  Created by albaraa alsayed on 11/02/1448 AH.
//

import SwiftUI

extension SafetyLevel {
    var color: Color {
            switch self {
            case .safe:
                return Color.Teal.teal500
            case .caution:
                return Color.Yellow.yellow500
            case .unsafe:
                return Color.Red.red500
            }
        }
}
