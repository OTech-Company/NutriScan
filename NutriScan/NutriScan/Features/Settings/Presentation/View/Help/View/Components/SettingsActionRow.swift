//
//  SettingsActionRow.swift
//  NutriScan
//
//  Created by Mina_Wagdy on 30/07/2026.
//

import SwiftUI

struct SettingsActionRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                MenuIconBadge(icon: icon)
                
                Text(title)
                    .font(Font.AppFont.textPrimary)
                    .foregroundColor(Color.SettingsSemantic.rowTitle)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.SettingsSemantic.rowChevron)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 12)
            .background(Color.SettingsSemantic.rowBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}
