//
//  Gender.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 17/07/2026.
//
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

    var imageName: String {
        switch self {
        case .male: return "male"
        case .female: return "female"
        }
    }
}

