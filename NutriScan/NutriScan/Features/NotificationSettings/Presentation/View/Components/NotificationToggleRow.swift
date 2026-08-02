//
//  NotificationToggleRow.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 01/08/2026.
//

import SwiftUI

struct NotificationToggleRow: View {
    let category: NotificationCategory
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 14) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.NotificationSemantic.iconBackground)
                    .frame(width: 36, height: 36)
                
                Image(systemName: category.icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.NotificationSemantic.iconTint)
            }
            
            // Title
            Text(category.displayTitle)
                .font(Font.AppFont.textPrimary)
                .foregroundColor(Color.NotificationSemantic.titleText)
            
            Spacer()
            
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
