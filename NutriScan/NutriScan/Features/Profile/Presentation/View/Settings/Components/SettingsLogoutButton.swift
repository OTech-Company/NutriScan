//
//  SettingsLogoutButton.swift
//  NutriScan
//

import SwiftUI

// MARK: - Logout Button
struct SettingsLogoutButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Icon Badge
                Image("logout")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.SettingsSemantic.logoutIcon)
                    .frame(width: 45, height: 45)
                    .background(Color.SettingsSemantic.logoutIconBackground)
                    .clipShape(Circle())

                Text("Logout")
                    .font(Font.AppFont.textPrimary)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.SettingsSemantic.logoutTitle)

                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color.SettingsSemantic.logoutRawBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.SettingsSemantic.logoutBorder, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SettingsLogoutButton(action: {})
        .padding()
        .background(Color.SettingsSemantic.screenBackground)
}
