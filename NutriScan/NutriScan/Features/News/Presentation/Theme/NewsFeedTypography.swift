//
//  NewsFeedTypography.swift
//  NewsFeed (Feature)
//
//  Maps the shared `Font.AppFont` tokens (Extensions/Fonts+Extenstion.swift,
//  PlusJakartaSans / LexendDeca) onto the semantic roles this screen needs.
//

import SwiftUI

enum NewsFeedTypography {
    static let screenTitle = Font.AppFont.subtitle1
    static let chip = Font.AppFont.textSecondary
    static let articleTitle = Font.AppFont.textSecondary
    static let articleCaption = Font.AppFont.textCaption
    static let metadataStrong = Font.AppFont.textSecondary
    static let metadata = Font.AppFont.textSecondary

    // Article detail aliases retained for the existing sheet.
    static let cardTitle = Font.AppFont.plusJakartaSansSemiBold16
    static let cardBody = Font.AppFont.textSecondary
    static let eyebrow = Font.AppFont.lexendDecaMedium11
    static let caption = Font.AppFont.textCaption
    static let button = Font.AppFont.plusJakartaSansMedium16
}
