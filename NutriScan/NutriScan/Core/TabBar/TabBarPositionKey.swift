//
//  TabBarPositionKey.swift
//  NutriScan
//
//  Created by albaraa alsayed on 29/01/1448 AH.
//

import SwiftUI

struct TabBarPositionKey: PreferenceKey {
    static var defaultValue: [AppTab: CGFloat] = [:]
    
    static func reduce(value: inout [AppTab: CGFloat], nextValue: () -> [AppTab: CGFloat]) {
        value.merge(nextValue()) { $1 }
    }
}
