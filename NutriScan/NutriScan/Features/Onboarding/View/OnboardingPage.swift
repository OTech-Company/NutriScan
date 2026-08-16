//
//  OnboardingPage.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 12/01/1448 AH.
//

import Foundation
import UIKit

enum OnboardingPage: Int, CaseIterable {
    case scanLabels, knowWhatsSafe, shopWithConfidence
    
    var lightImage: String {
        switch self {
        case .scanLabels: return "onboarding-image-1"
        case .knowWhatsSafe: return "onboarding-image-2"
        case .shopWithConfidence: return "onboarding-image-3"
        }
    }
    
    var darkImage: String {
        switch self {
        case .scanLabels: return "onboarding-night-1"
        case .knowWhatsSafe: return "onboarding-night-2"
        case .shopWithConfidence: return "onboarding-night-3"
        }
    }

    var imageName: String {
        UITraitCollection.current.userInterfaceStyle == .dark ? darkImage : lightImage
    }
    
    var title: String {
        switch self {
        case .scanLabels: return LocalizationKeys.Onboarding.scanLabelsTitle.localized
        case .knowWhatsSafe: return LocalizationKeys.Onboarding.knowWhatsSafeTitle.localized
        case .shopWithConfidence: return LocalizationKeys.Onboarding.shopWithConfidenceTitle.localized
        }
    }
    
    var description: String {
        switch self {
        case .scanLabels: return LocalizationKeys.Onboarding.scanLabelsDesc.localized
        case .knowWhatsSafe: return LocalizationKeys.Onboarding.knowWhatsSafeDesc.localized
        case .shopWithConfidence: return LocalizationKeys.Onboarding.shopWithConfidenceDesc.localized
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .scanLabels, .knowWhatsSafe: return LocalizationKeys.Onboarding.next.localized
        case .shopWithConfidence: return LocalizationKeys.Onboarding.letsStart.localized
        }
    }
}
