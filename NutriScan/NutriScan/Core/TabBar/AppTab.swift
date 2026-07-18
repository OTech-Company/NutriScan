//
//  AppTab.swift
//  NutriScan
//
//  Created by albaraa alsayed on 29/01/1448 AH.
//

import Foundation

enum AppTab: String, CaseIterable {
    case home = "house"
    case history = "clock.arrow.circlepath"
    case scan = "viewfinder"
    case bookmark = "bookmark"
    case profile = "person"
    
    var filledIcon: String {
        switch self {
        case .home: return "house.fill"
        case .history: return "clock.fill" // Or an appropriate filled clock
        case .scan: return "viewfinder" // scan doesn't change
        case .bookmark: return "bookmark.fill"
        case .profile: return "person.fill"
        }
    }
}
