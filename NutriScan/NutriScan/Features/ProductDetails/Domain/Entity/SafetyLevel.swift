//
//  SafetyLevel.swift
//  NutriScan
//
//  Created by albaraa alsayed on 11/02/1448 AH.
//

import Foundation

enum SafetyLevel: String, CaseIterable {
    case safe = "Safe"
    case caution = "Caution"
    case unsafe = "Unsafe"

    var localizedTitle: String {
        switch self {
        case .safe: return LocalizationKeys.Scan.safe.localized
        case .caution: return LocalizationKeys.Scan.caution.localized
        case .unsafe: return LocalizationKeys.Scan.unsafe.localized
        }
    }
}
