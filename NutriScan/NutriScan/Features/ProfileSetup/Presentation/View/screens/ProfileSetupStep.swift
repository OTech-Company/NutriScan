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
            return [TitleSegment("What's your "), TitleSegment("gender", color: Color.ProfileSetupSemantic.accent)]
        case .birthdate:
            return [TitleSegment("When's your "), TitleSegment("birthday", color: Color.ProfileSetupSemantic.accent)]
        case .weight:
            return [TitleSegment("Your current "), TitleSegment("weight", color: Color.ProfileSetupSemantic.accent)]
        case .height:
            return [TitleSegment("How "), TitleSegment("tall", color: Color.ProfileSetupSemantic.accent), TitleSegment(" are you?")]
        case .healthProfile:
            return [TitleSegment("Your health "), TitleSegment("profile", color: Color.ProfileSetupSemantic.accent)]
        }
    }

    var subtitle: String {
        switch self {
        case .gender:
            return "This helps us personalize your calorie and nutrition targets."
        case .birthdate:
            return "Your age helps us fine-tune your daily recommendations."
        case .weight:
            return "Your weight helps us estimate your daily calorie needs more accurately."
        case .height:
            return "We'll use your height to personalize your nutrition insights and calorie calculations."
        case .healthProfile:
            return "Tell us a bit more so we can tailor your plan."
        }
    }
}
