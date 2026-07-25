//
//  ProfileHeaderFailureView.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 26/07/2026.
//

import SwiftUI

struct ProfileHeaderFailureView: View {
    let message: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 24))
                .foregroundColor(.red)
                .frame(width: 56, height: 56)

            VStack(alignment: .leading, spacing: 4) {
                Text("Failed to load profile")
                    .font(Font.AppFont.title4)
                    .foregroundColor(Color.ProfileSemantics.userName)

                Text(message)
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(.red.opacity(0.8))
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding(.horizontal, ProfileSemantics.Spacing.horizontalPadding)
        .padding(.top, 42)
        .padding(.bottom, 42)
    }
}

#Preview {
    ProfileHeaderFailureView(message: "No internet connection")
        .background(Color.ProfileSemantics.headerBackground)
}
