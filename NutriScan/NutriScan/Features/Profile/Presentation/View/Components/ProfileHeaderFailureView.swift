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
        HStack(spacing: ProfileSemantics.Spacing.headerContentSpacing) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: ProfileSemantics.Sizes.errorIconSize))
                .foregroundColor(.red)
                .frame(
                    width: ProfileSemantics.Sizes.avatarDiameter,
                    height: ProfileSemantics.Sizes.avatarDiameter
                )

            VStack(alignment: .leading, spacing: ProfileSemantics.Spacing.tinySpacing) {
                Text(LocalizationKeys.Profile.failedToLoad.localized)
                    .font(Font.AppFont.title4)
                    .foregroundColor(Color.ProfileSemantics.userName)

                Text(message)
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(.red.opacity(ProfileSemantics.Sizes.errorTextOpacity))
                    .lineLimit(ProfileSemantics.Sizes.singleLine)
            }
            Spacer()
        }
        .padding(.horizontal, ProfileSemantics.Spacing.horizontalPadding)
        .padding(.top, ProfileSemantics.Spacing.headerVerticalPadding)
        .padding(.bottom, ProfileSemantics.Spacing.headerVerticalPadding)
    }
}

#Preview {
    ProfileHeaderFailureView(message: "No internet connection")
        .background(Color.ProfileSemantics.headerBackground)
}
