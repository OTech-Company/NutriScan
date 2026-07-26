//
//  ProfileHeaderSuccessView.swift
//  NutriScan
//
//  Created by Ahmed Nageh on 26/07/2026.
//

import SwiftUI

struct ProfileHeaderSuccessView: View {
    let state: ProfileState
    var onEdit: () -> Void

    var body: some View {
        HStack(spacing: ProfileSemantics.Spacing.headerContentSpacing) {
            CachedImage(
                urlString: state.avatarURL ?? AppConstants.defaultUserAvatarURL,
                failureImageName: "person.circle.fill",
                contentMode: .fill
            )
            .frame(
                width: ProfileSemantics.Sizes.avatarDiameter,
                height: ProfileSemantics.Sizes.avatarDiameter
            )
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.Teal.teal1400, lineWidth: ProfileSemantics.Border.avatarBorderWidth)
            )
            .opacity(ProfileSemantics.Sizes.fullOpacity)

            VStack(alignment: .leading, spacing: ProfileSemantics.Spacing.tinySpacing) {
                Text(state.fullName)
                    .font(Font.AppFont.title4)
                    .foregroundColor(Color.ProfileSemantics.userName)

                Text("\(state.streakDays) Day streak")
                    .font(Font.AppFont.textSecondary)
                    .foregroundColor(Color.ProfileSemantics.streakText)
                    .padding(
                        .horizontal,
                        ProfileSemantics.Spacing.streakPaddingHorizontal
                    )
                    .padding(
                        .vertical,
                        ProfileSemantics.Spacing.streakPaddingVertical
                    )
                    .background(Color.ProfileSemantics.streakBackground)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: ProfileSemantics.Radius.streakBadge
                        )
                    )
            }

            Spacer()

            Button(action: onEdit) {
                Image("edit_profile")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.ProfileSemantics.editIcon)
                    .frame(
                        width: ProfileSemantics.Sizes.editIconSize,
                        height: ProfileSemantics.Sizes.editIconSize
                    )
            }
        }
        .padding(.horizontal, ProfileSemantics.Spacing.horizontalPadding)
        .padding(.top, ProfileSemantics.Spacing.headerVerticalPadding)
        .padding(.bottom, ProfileSemantics.Spacing.headerVerticalPadding)
    }
}

#Preview {
    ProfileHeaderSuccessView(
        state: ProfileState(
            fullName: "Sara Omar",
            streakDays: 15
        ),
        onEdit: {}
    )
    .background(Color.ProfileSemantics.headerBackground)
}
