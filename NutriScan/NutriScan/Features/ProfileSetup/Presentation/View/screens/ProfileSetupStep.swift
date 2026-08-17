//
//  ProfileSetupStep.swift
//  NutriScan
//
//  Created by Osama Hosam on 18/07/2026.
//

import SwiftUI

enum ProfileSetupStep: Int, CaseIterable {
    case gender
    case birthdate
    case weight
    case height
    case healthProfile

    var stepNumber: Int { rawValue + 1 }
    static var totalSteps: Int { allCases.count - 1 }

    var titleSegments: [TitleSegment] {
        switch self {
        case .gender:
            return [
                TitleSegment(LocalizationKeys.ProfileSetup.genderTitlePrefix.localized),
                TitleSegment(LocalizationKeys.ProfileSetup.genderTitleHighlight.localized, color: Color.ProfileSetupSemantic.accent)
            ]
        case .birthdate:
            return [
                TitleSegment(LocalizationKeys.ProfileSetup.birthdateTitlePrefix.localized),
                TitleSegment(LocalizationKeys.ProfileSetup.birthdateTitleHighlight.localized, color: Color.ProfileSetupSemantic.accent)
            ]
        case .weight:
            return [
                TitleSegment(LocalizationKeys.ProfileSetup.weightTitlePrefix.localized),
                TitleSegment(LocalizationKeys.ProfileSetup.weightTitleHighlight.localized, color: Color.ProfileSetupSemantic.accent)
            ]
        case .height:
            var segments = [
                TitleSegment(LocalizationKeys.ProfileSetup.heightTitlePrefix.localized),
                TitleSegment(LocalizationKeys.ProfileSetup.heightTitleHighlight.localized, color: Color.ProfileSetupSemantic.accent)
            ]
            let suffix = LocalizationKeys.ProfileSetup.heightTitleSuffix.localized
            if !suffix.isEmpty {
                segments.append(TitleSegment(suffix))
            }
            return segments
        case .healthProfile:
            return [
                TitleSegment(LocalizationKeys.ProfileSetup.healthProfileStepTitlePrefix.localized),
                TitleSegment(LocalizationKeys.ProfileSetup.healthProfileStepTitleHighlight.localized, color: Color.ProfileSetupSemantic.accent)
            ]
        }
    }

    var subtitle: String {
        switch self {
        case .gender:
            return LocalizationKeys.ProfileSetup.genderSubtitle.localized
        case .birthdate:
            return LocalizationKeys.ProfileSetup.birthdateSubtitle.localized
        case .weight:
            return LocalizationKeys.ProfileSetup.weightSubtitle.localized
        case .height:
            return LocalizationKeys.ProfileSetup.heightSubtitle.localized
        case .healthProfile:
            return LocalizationKeys.ProfileSetup.healthProfileStepSubtitle.localized
        }
    }
}
