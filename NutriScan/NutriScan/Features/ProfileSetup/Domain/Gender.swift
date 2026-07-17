//
//  Gender.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 17/07/2026.
//

import SwiftUI

enum Gender: String, CaseIterable {
    case male
    case female

    var title: String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        }
    }

    func imageName(for colorScheme: ColorScheme) -> String {
        switch (self, colorScheme) {
        case (.male, .light):   return "maleLight"
        case (.male, .dark):    return "maleDark"
        case (.female, .light): return "femaleLight"
        case (.female, .dark):  return "femaleDark"
        default:                return "maleLight" // exhaustive fallback, .dark/.light are the only real cases
        }
    }
}
