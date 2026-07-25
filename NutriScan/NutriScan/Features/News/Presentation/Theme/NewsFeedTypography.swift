//
//  NewsFeedTypography.swift
//  NewsFeed (Feature)
//
//  Maps the shared `Font.AppFont` tokens (Extensions/Fonts+Extenstion.swift,
//  PlusJakartaSans / LexendDeca) onto the semantic roles this screen needs.
//

import SwiftUI

enum NewsFeedTypography {
    static let screenTitle = Font.AppFont.title2                       // 28 · PlusJakartaSans Bold
    static let cardTitle = Font.AppFont.plusJakartaSansSemiBold16       // 16 · PlusJakartaSans SemiBold
    static let cardBody = Font.AppFont.textSecondary                    // 14 · LexendDeca Regular
    static let eyebrow = Font.AppFont.lexendDecaMedium11                // 11 · LexendDeca Medium
    static let caption = Font.AppFont.textCaption                       // 12 · LexendDeca Light
    static let chip = Font.AppFont.lexendDecaRegular12                  // 12 · LexendDeca Regular
    static let button = Font.AppFont.plusJakartaSansMedium16            // 16 · PlusJakartaSans Medium
    static let emptyStateTitle = Font.AppFont.subtitle2                 // 18 · PlusJakartaSans Medium
}
