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
        VStack(spacing: ProfileSemantics.Spacing.menuRowSpacing) {
            MenuRowView(icon: "clock.arrow.circlepath", title: "Scan History", action: onScanHistory)
            MenuRowView(icon: "bell", title: "Notifications", action: onNotifications)
            MenuRowView(icon: "gearshape", title: "Settings", action: onSettings)
        }
    }
}
