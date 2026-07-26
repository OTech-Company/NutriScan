//
//  MenuRowView.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 26/07/2026.
//

import SwiftUI

// MARK: - Simple Navigation Row (Shared Component)
struct MenuRowView: View {
    let icon: String
    let title: String
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                MenuIconBadge(icon: icon)

                Text(title)
                    .font(Font.AppFont.textPrimary)
                    .foregroundColor(Color.SettingsSemantic.rowTitle)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
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

#Preview {
    MenuRowView(icon: "person.crop.circle.badge.pencil", title: "Profile Settings")
        .padding()
        .background(Color.SettingsSemantic.screenBackground)
}
