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
        case .scanLabels: return "Scan Food Labels\nInstantly"
        case .knowWhatsSafe: return "Know What's Safe\nfor You"
        case .shopWithConfidence: return "Shop with\nConfidence"
        }
    }
    
    var description: String {
        switch self {
        case .scanLabels: return "Point your camera at any food label and let AI read even the smallest Arabic and English ingredients in seconds."
        case .knowWhatsSafe: return "Get a personalized safety rating based on your allergies and health conditions, with simple explanations you can trust."
        case .shopWithConfidence: return "Discover healthier alternatives, avoid hidden risks, and make smarter food choices every time you shop."
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .scanLabels, .knowWhatsSafe: return "Next"
        case .shopWithConfidence: return "Let's Start"
        }
    }
}
