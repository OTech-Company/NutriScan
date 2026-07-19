//
//  EditProfileSemantics.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 19/07/2026.
//

import Foundation
import SwiftUI
enum EditProfileSemantics {
    enum Spacing {
        static let screenHorizontal: CGFloat = 20
        static let sectionVertical: CGFloat = 24
        static let fieldVertical: CGFloat = 12
        static let chipSpacing: CGFloat = 8
        static let headerNameSpacing: CGFloat = 2
        static let headerRowSpacing: CGFloat = 12
    }

    enum Sizes {
        static let avatarDiameter: CGFloat = 72
        static let editBadgeDiameter: CGFloat = 22
        static let fieldHeight: CGFloat = 52
        static let buttonHeight: CGFloat = 62
    }

    enum Radius {
        static let field: CGFloat = 14
        static let card: CGFloat = 16
    }

    enum Animation {
        static let chipSelection: SwiftUI.Animation = .spring(response: 0.3, dampingFraction: 0.8)
    }

    enum Shadow {
        static let buttonBlur: CGFloat = 15
        static let buttonYOffset: CGFloat = 10
    }
}
