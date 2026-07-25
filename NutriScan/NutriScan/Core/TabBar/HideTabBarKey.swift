//
//  HideTabBarKey.swift
//  NutriScan
//

import SwiftUI

struct HideTabBarKey: PreferenceKey {
    static var defaultValue: Bool = false
    
    /// `reduce` tells SwiftUI: "When you find more than one View at the same time assigning a value
    /// to the same Preference, merge them via OR - meaning if any one of them says true, let the final result be true."
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = value || nextValue()
    }
}

extension View {
    func hideCustomTabBar(_ hide: Bool = true) -> some View {
        preference(key: HideTabBarKey.self, value: hide)
    }
}
