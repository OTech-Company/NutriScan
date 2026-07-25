//
//  AppTabBarVisibility.swift
//  NutriScan
//
//  Created by albaraa alsayed on 24/07/2026.
//

import SwiftUI

final class AppTabBarVisibility: ObservableObject {
    static let shared = AppTabBarVisibility()
    
    @Published var isHidden: Bool = false
    
    private init() {}
}
