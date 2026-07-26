//
//  MenuIconBadge.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 26/07/2026.
//

import SwiftUI

// MARK: - Icon Badge (circular teal container)
struct MenuIconBadge: View {
    let icon: String

    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 17, weight: .medium))
            .foregroundColor(Color.SettingsSemantic.rowIconTint)
            .frame(width: 45, height: 45)
            .background(Color.SettingsSemantic.rowIconBackground)
            .clipShape(Circle())
    }
}

#Preview {
    MenuIconBadge(icon: "person.crop.circle.badge.pencil")
        .padding()
        .background(Color.SettingsSemantic.screenBackground)
}
