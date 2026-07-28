//
//  SharedProfileStore.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 28/07/2026.
//

import Foundation
import SwiftUI

@Observable
final class SharedProfileStore {
    var currentProfile: ProfileInfo?
    
    // We can also store the streak here since it's an app-wide concept
    var streakDays: Int = 0
    
    /// Helper to clear data on logout
    func clear() {
        currentProfile = nil
        streakDays = 0
    }
}
