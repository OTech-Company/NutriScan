//
//  ProfileSemantics.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//

import Foundation
import SwiftUI

enum ProfileSemantics {
    enum Sizes {
        static let avatarDiameter: CGFloat = 56
        static let editIconSize: CGFloat = 24
        static let memberCardWidth: CGFloat = 90
        static let memberCardHeight: CGFloat = 95
        static let addMemberIconSize: CGFloat = 24
        static let addMemberIconCornerRadius: CGFloat = 7
    }

    enum Spacing {
        static let horizontalPadding: CGFloat = 16
        static let sectionSpacing: CGFloat = 24
        static let streakPaddingHorizontal: CGFloat = 8
        static let streakPaddingVertical: CGFloat = 2
        static let streakGap: CGFloat = 10
        static let familyMembersGap: CGFloat = 8
    }

    enum Radius {
        static let containerTop: CGFloat = 24
        static let streakBadge: CGFloat = 8
        static let familyMembersContainerLight: CGFloat = 16
        static let familyMembersContainerDark: CGFloat = 22
        static let memberCardRadius: CGFloat = 12
    }

    enum Border {
        static let dashedWidthLight: CGFloat = 1
        static let dashedWidthDark: CGFloat = 2
        static let dashPattern: [CGFloat] = [6, 4]
        static let avatarBorderWidth: CGFloat = 1
        static let memberCardBorderWidth: CGFloat = 1
    }

    enum FamilySection {
        static let containerHeight: CGFloat = 131
        static let containerWidthLight: CGFloat = 330
        static let containerWidthDark: CGFloat = 373
    }

    enum Animation {
        static let navigationTransition: SwiftUI.Animation = .easeInOut(duration: 0.3)
        static let scrollTransition: SwiftUI.Animation = .easeInOut(duration: 0.25)
    }
}
