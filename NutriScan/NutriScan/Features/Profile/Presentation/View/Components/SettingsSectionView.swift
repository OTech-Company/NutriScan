//
//  SettingsSectionView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//
import SwiftUI

struct SettingsSectionView: View {
    var onScanHistory: () -> Void
    var onNotifications: () -> Void
    var onSettings: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            SettingsNavRow(icon: "clock.arrow.circlepath", title: "Scan History", action: onScanHistory)
            SettingsNavRow(icon: "bell", title: "Notifications", action: onNotifications)
            SettingsNavRow(icon: "gearshape", title: "Settings", action: onSettings)
        }
    }
}
