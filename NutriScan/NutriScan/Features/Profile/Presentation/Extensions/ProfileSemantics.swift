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
        static let familyMemberImageSize: CGFloat = 24
        static let addMemberIconCornerRadius: CGFloat = 7
        static let showDetailsButtonWidth: CGFloat = 75
        static let showDetailsButtonHeight: CGFloat = 25
        static let addMemberPlusIconSize: CGFloat = 12
        
        // MARK: - Added Sizes
        static let sheetDragHandleWidth: CGFloat = 40
        static let sheetDragHandleHeight: CGFloat = 5
        static let sheetAvatarSize: CGFloat = 90
        static let sheetAvatarIconSize: CGFloat = 28
        static let buttonTextSize: CGFloat = 16
        static let decorationCircleSize: CGFloat = 220
        static let minimumScaleFactor: CGFloat = 0.8
        static let fullOpacity: Double = 1.0
        static let shimmerOpacity: Double = 0.15
        static let shimmerTextWidth: CGFloat = 140
        static let shimmerTextHeight: CGFloat = 22
        static let shimmerSubtextWidth: CGFloat = 90
        static let shimmerSubtextHeight: CGFloat = 20
        static let errorIconSize: CGFloat = 24
        static let errorTextOpacity: Double = 0.8
        static let singleLine: Int = 1
    }

    enum Spacing {
        static let horizontalPadding: CGFloat = 22
        static let sectionSpacing: CGFloat = 24
        static let streakPaddingHorizontal: CGFloat = 8
        static let streakPaddingVertical: CGFloat = 2
        static let streakGap: CGFloat = 10
        static let familyMembersGap: CGFloat = 8
        static let addMemberSpacing: CGFloat = 6
        
        // MARK: - Added Spacing
        static let tinySpacing: CGFloat = 4
        static let smallSpacing: CGFloat = 8
        static let menuRowSpacing: CGFloat = 12
        static let sectionTitleSpacing: CGFloat = 12
        static let headerContentSpacing: CGFloat = 14
        static let sheetBottomPadding: CGFloat = 32
        static let headerVerticalPadding: CGFloat = 42
        static let decorationOffsetX: CGFloat = 90
        static let decorationOffsetY: CGFloat = -100
    }

    enum Radius {
        static let containerTop: CGFloat = 24
        static let streakBadge: CGFloat = 8
        static let familyMembersContainerLight: CGFloat = 16
        static let familyMembersContainerDark: CGFloat = 22
        static let memberCardRadius: CGFloat = 12
        static let showDetailsButton: CGFloat = 8
        
        // MARK: - Added Radius
        static let zero: CGFloat = 0
        static let dragHandle: CGFloat = 3
        static let shimmerSmall: CGFloat = 4
        static let shimmerMedium: CGFloat = 6
    }

    enum Border {
        static let dashedWidthLight: CGFloat = 2
        static let dashedWidthDark: CGFloat = 2
        static let dashPattern: [CGFloat] = [6, 4]
        static let avatarBorderWidth: CGFloat = 1
        static let memberCardBorderWidth: CGFloat = 1
        
        // MARK: - Added Borders
        static let avatarThickBorderWidth: CGFloat = 1.5
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
    
    enum HeaderLayout {
        static let headerHeight: CGFloat = 140
    }
}
