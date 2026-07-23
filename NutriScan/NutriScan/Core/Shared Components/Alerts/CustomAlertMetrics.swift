//
//  CustomAlertMetrics.swift
//  NutriScan
//
//  Created by albaraa alsayed on 23/07/2026.
//

import Foundation

struct CustomAlertMetrics {
    // Card metrics
    static let cardWidth: CGFloat = 284
    static let cardHeight: CGFloat = 160
    static let cardCornerRadius: CGFloat = 24
    
    // Icon badge metrics
    static let iconBadgeSize: CGFloat = 60
    static let iconSize: CGFloat = 28
    static let iconBadgeCornerRadius: CGFloat = 20
    
    // Spacing and Offsets
    static let topSpacerHeight: CGFloat = 44
    static let iconVerticalOffset: CGFloat = -30
    static let outerTopPadding: CGFloat = 30
    
    // Padding
    static let horizontalPadding: CGFloat = 16
    static let titleBottomPadding: CGFloat = 6
    static let buttonSpacing: CGFloat = 12
    static let bottomPadding: CGFloat = 16
    
    // Button metrics
    static let buttonCornerRadius: CGFloat = 12
    static let buttonHeight: CGFloat = 36
    
    // Animation timing parameters (Entrance)
    static let backdropEntranceDuration: Double = 0.15
    
    static let cardEntranceDelay: Double = 0.05
    static let cardEntranceResponse: Double = 0.5
    static let cardEntranceDamping: Double = 0.7
    static let cardInitialScale: CGFloat = 0.75
    static let cardInitialOffsetY: CGFloat = 16
    
    static let buttonsEntranceDelay: Double = 0.1
    static let buttonsInitialOffsetY: CGFloat = 10
    
    static let iconEntranceDelay: Double = 0.15
    static let iconEntranceResponse: Double = 0.38
    static let iconEntranceDamping: Double = 0.58
    static let iconInitialScale: CGFloat = 0.5
    static let iconInitialRotation: Double = -10
    
    // Animation timing parameters (Exit)
    static let cardExitDuration: Double = 0.15
    static let cardExitScale: CGFloat = 0.9
    static let backdropExitDuration: Double = 0.15
    static let backdropExitDelay: Double = 0.05
}
