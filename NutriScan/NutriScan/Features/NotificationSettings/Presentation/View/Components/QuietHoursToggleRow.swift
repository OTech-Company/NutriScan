//
//  QuietHoursToggleRow.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 05/08/2026.
//

import SwiftUI

struct QuietHoursToggleRow: View {
    let timeRangeText: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 14) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.NotificationSemantic.iconBackground)
                    .frame(width: 36, height: 36)
                
                Image(systemName: "bell.slash.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.NotificationSemantic.iconTint)
            }
            
            // Title
            Text("Do not disturb")
                .font(Font.AppFont.textPrimary)
                .foregroundColor(Color.NotificationSemantic.titleText)
            
            Spacer()

            Text(timeRangeText)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color.NotificationSemantic.quietHoursTimeText)
            
            // Toggle
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Color.NotificationSemantic.toggleTint)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.NotificationSemantic.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
