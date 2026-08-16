//
//  CustomAlertConfig.swift
//  NutriScan
//
//  Created by albaraa alsayed on 23/07/2026.
//

import SwiftUI

enum CustomAlertButtonRole: Equatable, Sendable {
    case standard
    case cancel
    case destructive

    var backgroundColor: Color {
        switch self {
        case .standard:
            return Color.Teal.teal1000
        case .cancel:
            return Color.CustomAlertSemantic.secondaryButtonBackground
        case .destructive:
            return Color.Red.red500
        }
    }

    var foregroundColor: Color {
        switch self {
        case .cancel:
            return Color.CustomAlertSemantic.secondaryButtonText
        case .standard, .destructive:
            return .white
        }
    }
}

struct CustomAlertButton: Equatable, Sendable {
    let title: String
    let role: CustomAlertButtonRole

    init(_ title: String, role: CustomAlertButtonRole = .standard) {
        self.title = title
        self.role = role
    }
}

struct CustomAlertConfig: Sendable {
    let type: CustomAlertType
    let title: String
    let message: String
    let primaryButton: CustomAlertButton
    let secondaryButton: CustomAlertButton?
    
    init(
        type: CustomAlertType,
        title: String,
        message: String,
        primaryButton: CustomAlertButton = CustomAlertButton("OK"),
        secondaryButton: CustomAlertButton? = nil
    ) {
        self.type = type
        self.title = title
        self.message = message
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }
}
