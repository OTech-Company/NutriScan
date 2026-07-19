//
//  AppTab.swift
//  NutriScan
//
//  Created by albaraa alsayed on 29/01/1448 AH.
//

import Foundation

enum AppTab: String, CaseIterable {
    case home = "home-stroke"
    case calories = "calories-stroke"
    case scan = "scan"
    case bookmark = "bookmark-stroke"
    case profile = "profile-stroke"
    
    var filledIcon: String {
        switch self {
        case .home: return "home-fill"
        case .calories: return "calories-fill"
        case .scan: return "scan"
        case .bookmark: return "bookmark-fill"
        case .profile: return "profile-fill"
        }
    }
}
