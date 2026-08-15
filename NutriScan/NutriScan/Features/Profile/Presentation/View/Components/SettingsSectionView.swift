//
//  SettingsSectionView.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 24/07/2026.
//
import SwiftUI

struct SettingsSectionView: View {
    var onScanHistory: () -> Void
    var onCaloriesHistory: () -> Void
    var onNotifications: () -> Void
    var onSettings: () -> Void

    var body: some View {
        VStack(spacing: ProfileSemantics.Spacing.menuRowSpacing) {
            MenuRowView(icon: "clock.arrow.circlepath", title: LocalizationKeys.Profile.scanHistory.localized, action: onScanHistory)
            MenuRowView(icon: "flame", title: LocalizationKeys.Profile.caloriesHistory.localized, action: onCaloriesHistory)
            MenuRowView(icon: "bell", title: LocalizationKeys.Profile.notifications.localized, action: onNotifications)
            MenuRowView(icon: "gearshape", title: LocalizationKeys.Profile.settings.localized, action: onSettings)
        }
    }
}
